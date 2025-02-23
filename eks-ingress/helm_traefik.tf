resource "helm_release" "traefik_controller" {
  count = var.ingress_nlb.ingress_type == "traefik" ? 1 : 0

  name       = "traefik"
  namespace  = "traefik"
  chart      = "traefik"
  repository = "https://traefik.github.io/charts"
  version    = "34.4.0"

  create_namespace = true

  set {
    name  = "ingressRoute.dashboard.enabled"
    value = "true"
  }

  set {
    name  = "deployment.kind"
    value = var.ingress_controller_config.kind
  }

  set {
    name  = "service.internal.enabled"
    value = "true"
  }

  set {
    name  = "publishService.enable"
    value = "true"
  }

  set {
    name  = "service.type"
    value = "NodePort"
  }

  set {
    name  = "autoscaling.enabled"
    value = "true"
  }


  set {
    name  = "autoscaling.minReplicas"
    value = var.ingress_controller_config.min_replicas
  }

  set {
    name  = "autoscaling.maxReplicas"
    value = var.ingress_controller_config.max_replicas
  }

  set {
    name  = "resources.requests.cpu"
    value = var.ingress_controller_config.requests_cpu
  }

  set {
    name  = "resources.requests.memory"
    value = var.ingress_controller_config.requests_memory
  }

  set {
    name  = "resources.limits.cpu"
    value = var.ingress_controller_config.limits_cpu
  }

  set {
    name  = "resources.limits.memory"
    value = var.ingress_controller_config.limits_memory
  }

  depends_on = [
    helm_release.karpenter
  ]
}

#
# Ingress Controller -> service.type = NodePort
# TargetGroupBinding - > targetType: instance
resource "kubectl_manifest" "traefik_targetgroupbinding_80" {
  count     = var.ingress_nlb.create == true && var.ingress_nlb.ingress_type == "traefik" ? 1 : 0
  yaml_body = <<YAML
apiVersion: elbv2.k8s.aws/v1beta1
kind: TargetGroupBinding
metadata:
  name: ingress-traefik
  namespace: traefik
spec:
  serviceRef:
    name: traefik
    port: 80
  targetGroupARN: ${aws_lb_target_group.main[0].arn}
  targetType: instance
YAML
  depends_on = [
    helm_release.traefik_controller,
    helm_release.alb_ingress_controller # due to TargetGroupBinding
  ]
}
