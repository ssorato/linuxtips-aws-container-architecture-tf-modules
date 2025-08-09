resource "helm_release" "grafana" {
  name       = "grafana"
  chart      = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  namespace  = "grafana"

  create_namespace = true

  values = [
    local.grafana["values"]
  ]


  depends_on = [
    module.eks-observability,
    aws_eks_pod_identity_association.efs_csi,
    aws_eks_addon.efs_csi
  ]
}
