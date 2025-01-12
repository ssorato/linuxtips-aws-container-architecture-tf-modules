data "aws_ssm_parameter" "vpc" {
  name = var.ssm_vpc
}

data "aws_ssm_parameter" "public_subnets" {
  count = length(var.ssm_public_subnets)
  name  = var.ssm_public_subnets[count.index]
}

data "aws_ssm_parameter" "private_subnets" {
  count = length(var.ssm_private_subnets)
  name  = var.ssm_private_subnets[count.index]
}

data "aws_ssm_parameter" "pod_subnets" {
  count = length(var.ssm_pod_subnets)
  name  = var.ssm_pod_subnets[count.index]
}

data "aws_ssm_parameter" "natgw_eips" {
  count = length(var.ssm_natgw_eips)
  name  = var.ssm_natgw_eips[count.index]
}

data "aws_eip" "eips" {
  count = length(data.aws_ssm_parameter.natgw_eips)
  id    = data.aws_ssm_parameter.natgw_eips[count.index].value
}

data "aws_eks_cluster_auth" "default" {
  #name = aws_eks_cluster.main.id
  name = var.project_name
}

data "aws_caller_identity" "current" {}
