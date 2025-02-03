resource "aws_launch_template" "eks_node" {
  for_each = var.node_group

  name = format("%s-%s", aws_eks_cluster.main.id, each.key)

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = each.value.volume_size
      volume_type = "gp3"
    }
  }

  ebs_optimized = true

  monitoring {
    enabled = false
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = format("%s-%s", aws_eks_cluster.main.id, each.key)
    }
  }

  user_data = base64encode(templatefile("${path.module}/files/user-data.tpl", {
    CLUSTER_NAME                     = aws_eks_cluster.main.id
    KUBERNETES_ENDPOINT              = aws_eks_cluster.main.endpoint
    KUBERNETES_CERTIFICATE_AUTHORITY = aws_eks_cluster.main.certificate_authority.0.data
  }))
}

resource "aws_eks_node_group" "main" {
  for_each = var.node_group

  cluster_name    = aws_eks_cluster.main.id
  node_group_name = format("%s-%s", aws_eks_cluster.main.id, each.key)
  node_role_arn   = aws_iam_role.eks_nodes_role.arn
  subnet_ids      = data.aws_ssm_parameter.pod_subnets[*].value

  instance_types = each.value.instance_sizes

  launch_template {
    id      = aws_launch_template.eks_node[each.key].id
    version = aws_launch_template.eks_node[each.key].latest_version
  }

  scaling_config {
    desired_size = each.value.desired
    max_size     = each.value.max
    min_size     = each.value.min
  }

  capacity_type = each.value.capacity_type
  ami_type      = each.value.ami_type

  labels = merge(
    each.value.labels,
    {
      "capacity/type" = each.value.capacity_type
    }
  )

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
      Name                                        = format("%s-on-demand", aws_eks_cluster.main.id),
      "kubernetes.io/cluster/${var.project_name}" = "owned"
    },
    var.common_tags
  )

  depends_on = [
    aws_eks_access_entry.nodes
  ]
}