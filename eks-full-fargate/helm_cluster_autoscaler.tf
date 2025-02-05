locals {
  asg = flatten([
    for name, params in var.node_group : [{
      name    = format("%s-asg", name)
      maxSize = params.max
      minSize = params.min
    }]
  ])
}

resource "helm_release" "cluster_autoscaler" {
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"

  name = "aws-cluster-autoscaler"

  namespace        = "kube-system"
  create_namespace = true

  set {
    name  = "replicaCount"
    value = 1
  }

  set {
    name  = "awsRegion"
    value = var.region
  }

  set {
    name  = "rbac.serviceAccount.create"
    value = true
  }

  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.autoscaler.arn
  }

  dynamic "set" {
    for_each = var.node_group
    content {
      name  = format("autoscalingGroups[%s].name", index(keys(var.node_group), set.key))
      value = aws_eks_node_group.main[set.key].resources[0].autoscaling_groups[0].name
    }
  }

  dynamic "set" {
    for_each = var.node_group
    content {
      name  = format("autoscalingGroups[%s].maxSize", index(keys(var.node_group), set.key))
      value = lookup(var.node_group[set.key], "max")
    }
  }

  dynamic "set" {
    for_each = var.node_group
    content {
      name  = format("autoscalingGroups[%s].minSize", index(keys(var.node_group), set.key))
      value = lookup(var.node_group[set.key], "min")
    }
  }

  depends_on = [
    aws_eks_cluster.main,
    aws_eks_node_group.main,
  ]
}
