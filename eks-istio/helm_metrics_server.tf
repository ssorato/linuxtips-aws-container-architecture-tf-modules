resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metrics-server"
  namespace  = "kube-system"

  wait = false

  version = "7.2.16"

  set {
    name  = "apiService.create"
    value = "true"
  }

  # # Prometheus metrics
  # set {
  #   name  = "serviceMonitor.enabled"
  #   value = "true"
  # }

  # #
  # # --kubelet-insecure-tls=true
  # # --kubelet-preferred-address-types=InternalIP
  # # now metric server is ready ...
  # #
  # set {
  #   name  = "extraArgs[0]"
  #   value = "--kubelet-insecure-tls=true"
  # }

  set {
    name  = "extraArgs[1]"
    value = "--kubelet-preferred-address-types=InternalIP"
  }

  depends_on = [
    aws_eks_cluster.main,
    aws_eks_fargate_profile.karpenter
  ]
}