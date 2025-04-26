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


# keda-operator on fargate profile is not able to get iam role so it's unable to GetQueueAttributes about sqs

# resource "aws_eks_fargate_profile" "keda" {
#   cluster_name         = aws_eks_cluster.main.name
#   fargate_profile_name = "keda"

#   pod_execution_role_arn = aws_iam_role.fargate.arn

#   subnet_ids = data.aws_ssm_parameter.pod_subnets[*].value

#   selector {
#     namespace = "keda"
#   }

#   tags = merge(
#     {
#       Name = format("fargate-keda-profile-%s", var.project_name)
#     },
#     var.common_tags
#   )
# }

resource "aws_eks_fargate_profile" "rollouts" {
  cluster_name         = aws_eks_cluster.main.name
  fargate_profile_name = "argo-rollouts"

  pod_execution_role_arn = aws_iam_role.fargate.arn

  subnet_ids = data.aws_ssm_parameter.pod_subnets[*].value

  selector {
    namespace = "argo-rollouts"
  }

  tags = merge(
    {
      Name = format("fargate-argo-rollouts-profile-%s", var.project_name)
    },
    var.common_tags
  )
}
