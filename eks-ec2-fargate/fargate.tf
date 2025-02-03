resource "aws_eks_fargate_profile" "chip" {
  cluster_name         = aws_eks_cluster.main.name
  fargate_profile_name = var.fargate_namespace

  pod_execution_role_arn = aws_iam_role.fargate.arn

  subnet_ids = data.aws_ssm_parameter.pod_subnets[*].value

  selector {
    namespace = var.fargate_namespace
  }

  tags = merge(
    {
      Name = format("fargate-profile-%s", var.project_name)
    },
    var.common_tags
  )
}
