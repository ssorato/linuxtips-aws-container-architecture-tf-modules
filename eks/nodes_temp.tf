resource "aws_eks_node_group" "main" {

  cluster_name    = aws_eks_cluster.main.id
  node_group_name = format("%s-node-group-spot", aws_eks_cluster.main.id)
  node_role_arn   = aws_iam_role.eks_nodes_role.arn
  subnet_ids      = data.aws_ssm_parameter.pod_subnets[*].value

  instance_types = var.node_group_temp.instances_size

  scaling_config {
    desired_size = var.node_group_temp.desired_size
    max_size     = var.node_group_temp.max_size
    min_size     = var.node_group_temp.min_size
  }

  capacity_type = "SPOT"

  labels = {
    "capacity/os"   = "BOTTLEROCKET"
    "capacity/arch" = "x86_64"
    "capacity/type" = "SPOT"
    "compute-type"  = "ec2"
  }

  tags = merge(
    {
      Name                                        = format("%s-node-group-spot", aws_eks_cluster.main.id),
      "kubernetes.io/cluster/${var.project_name}" = "owned"
    },
    var.common_tags
  )

  depends_on = [
    aws_eks_access_entry.nodes
  ]

  timeouts {
    create = "1h"
    update = "2h"
    delete = "2h"
  }

}