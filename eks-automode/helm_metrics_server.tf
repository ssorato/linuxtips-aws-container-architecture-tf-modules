resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metrics-server"
  namespace  = "kube-system"

  wait = false

  version = var.metrics_server_version

  set {
    name  = "apiService.create"
    value = "true"
  }

  set {
    name  = "nodeSelector.karpenter\\.sh/nodepool"
    value = "system"
  }

  set {
    name  = "tolerations[0].key"
    value = "CriticalAddonsOnly"
  }

  set {
    name  = "tolerations[0].operator"
    value = "Exists"
  }

  depends_on = [
    aws_eks_cluster.main
  ]
}
