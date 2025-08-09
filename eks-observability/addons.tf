data "aws_eks_addon_version" "efs" {
  addon_name         = "aws-efs-csi-driver"
  kubernetes_version = module.eks-observability.k8s_version
  most_recent        = true
}

resource "aws_eks_addon" "efs_csi" {
  cluster_name = module.eks-observability.cluster_name
  addon_name   = "aws-efs-csi-driver"

  addon_version               = data.aws_eks_addon_version.efs.version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    module.eks-observability
  ]
}

// EBS

data "aws_eks_addon_version" "ebs" {
  addon_name         = "aws-ebs-csi-driver"
  kubernetes_version = module.eks-observability.k8s_version
  most_recent        = true
}


resource "aws_eks_addon" "ebs_csi" {
  cluster_name = module.eks-observability.cluster_name
  addon_name   = "aws-ebs-csi-driver"

  addon_version               = data.aws_eks_addon_version.ebs.version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    module.eks-observability
  ]
}