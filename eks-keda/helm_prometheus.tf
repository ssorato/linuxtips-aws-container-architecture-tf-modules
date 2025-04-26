resource "helm_release" "prometheus" {

  name             = "prometheus"
  chart            = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  namespace        = "prometheus"
  create_namespace = true

  version = "69.3.2"

  # helm show values prometheus-community/kube-prometheus-stack
  values = [
    "${file("${path.module}/files/prometheus/helm-values.yaml")}"
  ]

  depends_on = [
    aws_eks_cluster.main,
    helm_release.karpenter
  ]
}


resource "kubectl_manifest" "grafana_gateway" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: grafana
  namespace: prometheus
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "${var.grafana_host}.${replace(var.route53.dns_name, "*.", "")}" 
YAML

  depends_on = [
    helm_release.istio_ingress,
    helm_release.prometheus
  ]
}

resource "kubectl_manifest" "grafana_virtual_service" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: grafana
  namespace: prometheus
spec:
  hosts:
  - ${var.grafana_host}.${replace(var.route53.dns_name, "*.", "")}
  gateways:
  - grafana
  http:
  - route:
    - destination:
        host: prometheus-grafana
        port:
          number: 80 
YAML

  depends_on = [
    helm_release.istio_ingress,
    kubectl_manifest.grafana_gateway
  ]
}
