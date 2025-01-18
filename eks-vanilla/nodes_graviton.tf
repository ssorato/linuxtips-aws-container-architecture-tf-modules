resource "aws_eks_node_group" "graviton" {
  cluster_name    = aws_eks_cluster.main.id
  node_group_name = format("%s-graviton", aws_eks_cluster.main.id)
  node_role_arn   = aws_iam_role.eks_nodes_role.arn
  subnet_ids      = data.aws_ssm_parameter.pod_subnets[*].value

  instance_types = var.nodes_graviton_instance_sizes

  scaling_config {
    desired_size = lookup(var.auto_scale_options, "desired")
    max_size     = lookup(var.auto_scale_options, "max")
    min_size     = lookup(var.auto_scale_options, "min")
  }

  capacity_type = "ON_DEMAND"
  ami_type      = "AL2023_ARM_64_STANDARD"

  labels = {
    "capacity/os"   = "AMAZON_LINUX"
    "capacity/arch" = "ARM64"
    "capacity/type" = "ON_DEMAND"
  }

  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size
    ]
  }

  timeouts {
    create = "1h"
    update = "2h"
    delete = "2h"
  }

  tags = merge(
    {
      Name                                        = format("%s-graviton", aws_eks_cluster.main.id),
      "kubernetes.io/cluster/${var.project_name}" = "owned"
    },
    var.common_tags
  )

  depends_on = [
    aws_eks_access_entry.nodes
  ]
}