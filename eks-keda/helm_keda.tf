resource "helm_release" "keda" {

  version = var.keda_version

  name             = "keda"
  chart            = "keda"
  repository       = "https://kedacore.github.io/charts"
  namespace        = "keda"
  create_namespace = true

  depends_on = [
    aws_eks_cluster.main,
    helm_release.karpenter,
    # keda-operator on fargate profile is not able to get iam role so it's unable to GetQueueAttributes about sqs. Review ...
    # aws_eks_fargate_profile.keda
  ]
}
