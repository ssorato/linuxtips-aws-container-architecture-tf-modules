resource "helm_release" "nginx_controller" {
  count = var.ingress_nlb.ingress_type == "nginx" ? 1 : 0

  name       = "ingress-nginx"
  namespace  = "ingress-nginx"
  chart      = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  version    = "4.11.3"

  create_namespace = true

  set {
    name  = "controller.service.internal.enabled"
    value = "true"
  }

  set {
    name  = "controller.publishService.enable"
    value = "true"
  }

  set {
    name  = "controller.service.type"
    value = "NodePort"
  }

  # Autoscaling
  set {
    name  = "controller.autoscaling.enabled"
    value = "true"
  }

  set {
    name  = "controller.autoscaling.minReplicas"
    value = var.ingress_controller_config.min_replicas
  }

  set {
    name  = "controller.autoscaling.maxReplicas"
    value = var.ingress_controller_config.max_replicas
  }

  # Capacity

  set {
    name  = "controller.resources.requests.cpu"
    value = var.ingress_controller_config.requests_cpu
  }

  set {
    name  = "controller.resources.requests.memory"
    value = var.ingress_controller_config.requests_memory
  }

  set {
    name  = "controller.resources.limits.cpu"
    value = var.ingress_controller_config.limits_cpu
  }

  set {
    name  = "controller.resources.limits.memory"
    value = var.ingress_controller_config.limits_memory
  }

  set {
    name  = "controller.kind"
    value = var.ingress_controller_config.kind
  }

  depends_on = [
    aws_eks_addon.cni,
    aws_eks_addon.coredns,
    aws_eks_addon.kubeproxy,
    helm_release.karpenter,
  ]
}

#
# Ingress Controller -> service.type = NodePort
# TargetGroupBinding - > targetType: instance
resource "kubectl_manifest" "nginx_targetgroupbinding_80" {
  count     = var.ingress_nlb.create == true && var.ingress_nlb.ingress_type == "nginx" ? 1 : 0
  yaml_body = <<YAML
apiVersion: elbv2.k8s.aws/v1beta1
kind: TargetGroupBinding
metadata:
  name: ingress-nginx
  namespace: ingress-nginx
spec:
  serviceRef:
    name: ingress-nginx-controller
    port: 80
  targetGroupARN: ${aws_lb_target_group.main[0].arn}
  targetType: instance
YAML
  depends_on = [
    helm_release.nginx_controller,
    helm_release.alb_ingress_controller # due to TargetGroupBinding
  ]
}
