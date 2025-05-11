resource "helm_release" "istio_base" {
  count      = var.enable_istio ? 1 : 0
  name       = "istio-base"
  chart      = "base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  namespace  = "istio-system"

  create_namespace = true

  version = var.istio_config.version

  depends_on = [
    aws_eks_cluster.main,
    helm_release.karpenter
  ]
}

resource "helm_release" "istiod" {
  count      = var.enable_istio ? 1 : 0
  name       = "istio"
  chart      = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  namespace  = "istio-system"

  create_namespace = true

  version = var.istio_config.version

  set {
    name  = "sidecarInjectorWebhook.rewriteAppHTTPProbe"
    value = "false"
  }

  set {
    name  = "meshConfig.enableTracing"
    value = "true"
  }

  set {
    name  = "meshConfig.defaultConfig.tracing.zipkin.address"
    value = "jaeger-collector.tracing.svc.cluster.local:9411"
  }

  depends_on = [
    helm_release.istio_base
  ]
}

resource "helm_release" "istio_ingress" {
  count            = var.enable_istio ? 1 : 0
  name             = "istio-ingressgateway"
  chart            = "gateway"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  namespace        = "istio-system"
  create_namespace = true

  version = var.istio_config.version

  set {
    name  = "service.type"
    value = "NodePort"
  }

  set {
    name  = "autoscaling.minReplicas"
    value = var.istio_config.min_replicas
  }

  set {
    name  = "autoscaling.targetCPUUtilizationPercentage"
    value = var.istio_config.cpu_threshold
  }

  depends_on = [
    helm_release.istio_base,
    helm_release.istiod
  ]
}

resource "kubectl_manifest" "target_binding_80" {
  count     = var.enable_istio ? 1 : 0
  yaml_body = <<YAML
apiVersion: elbv2.k8s.aws/v1beta1
kind: TargetGroupBinding
metadata:
  name: istio-ingress
  namespace: istio-system
spec:
  serviceRef:
    name: istio-ingressgateway
    port: 80
  targetGroupARN: ${data.aws_ssm_parameter.tg[0].value}
  targetType: instance
YAML
  depends_on = [
    helm_release.istio_ingress
  ]
}

#
# Mock used to force envoy side-car to open the port and avoid drain on target group targets
#
resource "kubectl_manifest" "mock_gateway" {
  count     = var.enable_istio ? 1 : 0
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: mock-istio
  namespace: istio-system
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - mock-istio.istio-system.svc.cluster.local
YAML
  depends_on = [
    helm_release.istio_ingress
  ]
}


resource "kubectl_manifest" "mock_virtual_service" {
  count     = var.enable_istio ? 1 : 0
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1
kind: VirtualService
metadata:
  name: mock-istio
  namespace: istio-system
spec:
  hosts:
  -  mock-istio.istio-system.svc.cluster.local
  http:
  - match:
    - uri:
        exact: /
    directResponse:
      status: 200
      body:
        string: "OK"
YAML
  depends_on = [
    helm_release.istio_ingress
  ]
}
