resource "helm_release" "istio_base" {
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

  // Jaeger tracing
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
  name             = "istio-ingressgateway"
  chart            = "gateway"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  namespace        = "istio-system"
  create_namespace = true

  version = var.istio_config.version

  # due to TargetGroupBinding
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


#
# LB -> TargetGroupBinding -> Istio Ingress Controller
#
# Ingress Controller -> service.type = NodePort
# TargetGroupBinding - > targetType: instance
#
resource "kubectl_manifest" "target_binding_80" {
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
  targetGroupARN: ${aws_lb_target_group.main.arn}
  targetType: instance
YAML
  depends_on = [
    helm_release.istio_ingress,
    helm_release.alb_ingress_controller
  ]
}
