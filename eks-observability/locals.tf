locals {
  grafana = {
    values : <<-VALUES
adminUser: admin
adminPassword: linuxtips        
        
persistence:
    enabled: true
    size: 10Gi
    storageClassName: efs-grafana
service:
    type: NodePort
initChownData:
    enabled: false

nodeSelector:
    karpenter.sh/nodepool: grafana


datasources:
  datasources.yaml:
    apiVersion: 1
    datasources:
      - name: Loki
        type: loki
        access: proxy
        url: http://loki-gateway.loki.svc.cluster.local
        isDefault: false
        jsonData:
          maxLines: 1000
          derivedFields:
          - datasourceName: Tempo
            datasourceUid: Tempo
            matcherRegex: '\\"traceID\\":\\"([^\\"]+)\\"'
            name: traceID
            url: $$${__value.raw}

      - name: Tempo
        type: tempo
        access: proxy
        url: http://tempo-gateway.tempo.svc.cluster.local
        basicAuth: false
        jsonData:
          tracesToMetrics:
            datasourceUid: 'Mimir'
          serviceMap:
            datasourceUid: 'Mimir'
          nodeGraph:
            enabled: true
          tracesToLogs:
            datasourceUid: 'Loki'

      - name: Mimir
        type: prometheus
        access: proxy
        url: http://mimir-nginx.mimir.svc.cluster.local:80/prometheus
        isDefault: true
        jsonData:
          prometheusType: Mimir
  VALUES
  }

  # Loki
  # By default a safe memory limit will be requested based on allocatedMemory value (floor (* 1.2 allocatedMemory)).

  loki = {
    values : <<-VALUES
loki:
    auth_enabled: false
    schemaConfig:
        configs:
        - from: "2024-04-01"
          store: tsdb
          object_store: s3
          schema: v13
          index:
            prefix: loki_index_
            period: 24h
    storage_config:
        aws:
            region: ${var.region}
            bucketnames: ${aws_s3_bucket.loki-chunks.id}
            s3forcepathstyle: false
    storage:
        type: s3
        bucketNames:
            chunks: ${aws_s3_bucket.loki-chunks.id}
            ruler: ${aws_s3_bucket.loki-ruler.id}
            admin: ${aws_s3_bucket.loki-admin.id}
    ingester:
        chunk_encoding: snappy
    querier:
        # Default is 4, if you have enough memory and CPU you can increase, reduce if OOMing
        max_concurrent: 4
    pattern_ingester:
        enabled: true
    limits_config:
        allow_structured_metadata: true
        volume_enabled: true
        retention_period: 672h

# -- Deployment mode lets you specify how to deploy Loki.
# There are 3 options:
# - SingleBinary: Loki is deployed as a single binary, useful for small installs typically without HA, up to a few tens of GB/day.
# - SimpleScalable: Loki is deployed as 3 targets: read, write, and backend. Useful for medium installs easier to manage than distributed, up to a about 1TB/day.
# - Distributed: Loki is deployed as individual microservices. The most complicated but most capable, useful for large installs, typically over 1TB/day.
# There are also 2 additional modes used for migrating between deployment modes:
# - SingleBinary<->SimpleScalable: Migrate from SingleBinary to SimpleScalable (or vice versa)
# - SimpleScalable<->Distributed: Migrate from SimpleScalable to Distributed (or vice versa)
# Note: SimpleScalable and Distributed REQUIRE the use of object storage.
deploymentMode: SimpleScalable

backend:
    replicas: 3
    persistence:
        storageClass: gp3

    nodeSelector:
        karpenter.sh/nodepool: loki

read:
    replicas: 3

    nodeSelector:
        karpenter.sh/nodepool: loki

write:
    replicas: 3 # To ensure data durability with replication
    persistence:
        storageClass: gp3
        # -- Enable StatefulSetAutoDeletePVC feature
        enableStatefulSetAutoDeletePVC: true
        # -- Size of persistent disk
        size: 10Gi

    nodeSelector:
        karpenter.sh/nodepool: loki        

gateway:
    replicas: 3
    service:
        type: NodePort

    nodeSelector:
        karpenter.sh/nodepool: loki

minio:
    enabled: false

chunksCache:
    allocatedMemory: 2048
    VALUES
  }

  tempo = {
    values : <<-VALUES
storage:
    trace:
        backend: s3
        s3:
            bucket: ${aws_s3_bucket.tempo.id}
            region: ${var.region}
            endpoint: s3.amazonaws.com
            forcepathstyle: false
gateway:
    enabled: true
    replicas: 3
    service:
        type: NodePort
    nodeSelector:
        karpenter.sh/nodepool: tempo
queryFrontend:
    replicas: 3
    query:
        enabled: false
    nodeSelector:
        karpenter.sh/nodepool: tempo       
querier:
    replicas: 3
    nodeSelector:
        karpenter.sh/nodepool: tempo       
distributor:
    enabled: true
    replicas: 3
    nodeSelector:
        karpenter.sh/nodepool: tempo           
ingester:
    replicas: 3
    nodeSelector:
        karpenter.sh/nodepool: tempo     
compactor:
    replicas: 3
    nodeSelector:
        karpenter.sh/nodepool: tempo       
traces:
    otlp:
        http:
            enabled: true
    grpc:
        enabled: true

metricsGenerator:
  enabled: true
  registry:
    external_labels:
      source: tempo
  config: 
    storage:
      remote_write: 
      - url: "http://mimir-nginx.mimir.svc.cluster.local:80/api/v1/push"
        send_exemplars: true
overrides:
  defaults:
    metrics_generator:
      processors: [service-graphs, span-metrics, local-blocks]

global_overrides:
  defaults:
    metrics_generator:
      processors: [service-graphs, span-metrics, local-blocks]
    VALUES
  }

  mimir = {
    values : <<-VALUES
enterprise:
    enabled: false
graphite:
    enabled: false
mimir:
  structuredConfig:
    limits:
      max_label_names_per_series: 50
      max_global_series_per_user: 150000000
    common:
      storage:
        backend: s3
        s3:
          endpoint: s3.${var.region}.amazonaws.com
          bucket_name: ${aws_s3_bucket.mimir.id}
          insecure: false
    blocks_storage:
      backend: s3
      s3:
        endpoint: s3.${var.region}.amazonaws.com
        bucket_name: ${aws_s3_bucket.mimir.id}
        insecure: false
    ruler_storage:
      backend: s3
      s3:
        endpoint: s3.${var.region}.amazonaws.com
        bucket_name: ${aws_s3_bucket.mimir_ruler.id}
        insecure: false

alertmanager:
  enabled: false

compactor:
  persistentVolume:
    storageClass: gp3
    size: 10Gi
    enableRetentionPolicy: true
    whenDeleted: Delete
    whenScaled: Delete
  resources:
    limits:
      memory: 2Gi
    requests:
      cpu: 1
      memory: 1Gi
  nodeSelector:
    karpenter.sh/nodepool: mimir  
    
distributor:
  replicas: 3
  resources:
    limits:
      memory: 3Gi
    requests:
      cpu: 1
      memory: 1Gi
  nodeSelector:
    karpenter.sh/nodepool: mimir
  persistence:
    storageClass: gp3

ingester:
  persistentVolume:
    storageClass: gp3
    size: 10Gi
    enableRetentionPolicy: true
    whenDeleted: Delete
    whenScaled: Delete
  replicas: 3
  resources:
    limits:
      memory: 3Gi
    requests:
      cpu: 1
      memory: 2Gi
  nodeSelector:
    karpenter.sh/nodepool: mimir

  zoneAwareReplication:
    enabled: false

admin-cache:
  enabled: false
  replicas: 3
  allocatedMemory: 64
  nodeSelector:
    karpenter.sh/nodepool: mimir 

chunks-cache:
  enabled: true
  replicas: 3
  allocatedMemory: 2048
  nodeSelector:
    karpenter.sh/nodepool: mimir  
  persistentVolume:
    storageClass: gp3
    size: 10Gi
    enableRetentionPolicy: true
    whenDeleted: Delete
    whenScaled: Delete

index-cache:
  enabled: true
  replicas: 3
  nodeSelector:
    karpenter.sh/nodepool: mimir  

metadata-cache:
  enabled: true
  replicas: 3
  nodeSelector:
    karpenter.sh/nodepool: mimir  

results-cache:
  enabled: true
  replicas: 3
  nodeSelector:
    karpenter.sh/nodepool: mimir  

minio:
  enabled: false

overrides_exporter:
  replicas: 1
  resources:
    limits:
      memory: 128Mi
    requests:
      cpu: 100m
      memory: 128Mi

querier:
  replicas: 1
  resources:
    limits:
      memory: 3Gi
    requests:
      cpu: 1
      memory: 2Gi
  nodeSelector:
    karpenter.sh/nodepool: mimir
 
query_frontend:
  replicas: 1
  resources:
    limits:
      memory: 3Gi
    requests:
      cpu: 1
      memory: 2Gi
  nodeSelector:
    karpenter.sh/nodepool: mimir

ruler:
  replicas: 1
  serviceAccount:
    create: true
  resources:
    limits:
      memory: 3Gi
    requests:
      cpu: 1
      memory: 2Gi
  nodeSelector:
    karpenter.sh/nodepool: mimir
 
store_gateway:
  persistentVolume:
    storageClass: gp3
    size: 10Gi
    enableRetentionPolicy: true
    whenDeleted: Delete
    whenScaled: Delete
  replicas: 3
  resources:
    limits:
      memory: 2Gi
    requests:
      cpu: 1
      memory: 1Gi
  nodeSelector:
    karpenter.sh/nodepool: mimir  
  topologySpreadConstraints: {}
  affinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchExpressions:
              - key: target # support for enterprise.legacyLabels
                operator: In
                values:
                  - store-gateway
          topologyKey: 'kubernetes.io/hostname'
        - labelSelector:
            matchExpressions:
              - key: app.kubernetes.io/component
                operator: In
                values:
                  - store-gateway
          topologyKey: 'kubernetes.io/hostname'
  zoneAwareReplication:
    topologyKey: 'kubernetes.io/hostname'

nginx:
  replicas: 3
  resources:
    limits:
      memory: 1Gi
    requests:
      cpu: 1
      memory: 512Mi
  service:
    type: NodePort
  nodeSelector:
    karpenter.sh/nodepool: mimir

gateway:
  replicas: 3
  resources:
    limits:
      memory: 1Gi
    requests:
      cpu: 1
      memory: 512Mi
  nodeSelector:
    karpenter.sh/nodepool: mimir

    VALUES
  }
}
