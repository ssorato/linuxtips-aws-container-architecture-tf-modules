resource "aws_eks_fargate_profile" "wildcard" {
  cluster_name         = aws_eks_cluster.main.name
  fargate_profile_name = "wildcard"

  pod_execution_role_arn = aws_iam_role.fargate.arn

  subnet_ids = data.aws_ssm_parameter.pod_subnets[*].value

  selector {
    namespace = "*"
  }

  tags = merge(
    {
      Name = format("fargate-wildcard-profile-%s", var.project_name)
    },
    var.common_tags
  )
}
