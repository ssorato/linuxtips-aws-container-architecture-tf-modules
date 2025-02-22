resource "aws_eks_fargate_profile" "kube_system" {
  cluster_name         = aws_eks_cluster.main.name
  fargate_profile_name = "kube-system"

  pod_execution_role_arn = aws_iam_role.fargate.arn

  subnet_ids = data.aws_ssm_parameter.pod_subnets[*].value

  selector {
    namespace = "kube-system"
  }


  tags = merge(
    {
      Name = format("fargate-kube-system-profile-%s", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_eks_fargate_profile" "karpenter" {
  cluster_name         = aws_eks_cluster.main.name
  fargate_profile_name = "karpenter"

  pod_execution_role_arn = aws_iam_role.fargate.arn

  subnet_ids = data.aws_ssm_parameter.pod_subnets[*].value

  selector {
    namespace = "karpenter"
  }

  tags = merge(
    {
      Name = format("fargate-karpenter-profile-%s", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_eks_fargate_profile" "nginx_ingress" {
  count = var.nginx_controller_config.use_fargate == true ? 1 : 0

  cluster_name         = aws_eks_cluster.main.name
  fargate_profile_name = "nginx-ingress"

  pod_execution_role_arn = aws_iam_role.fargate.arn

  subnet_ids = data.aws_ssm_parameter.pod_subnets[*].value

  selector {
    namespace = "ingress-nginx"
  }

  tags = merge(
    {
      Name = format("fargate-nginx-ingress-profile-%s", var.project_name)
    },
    var.common_tags
  )
}
