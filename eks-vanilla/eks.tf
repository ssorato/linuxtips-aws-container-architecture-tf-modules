resource "aws_eks_cluster" "main" {
  name    = var.project_name
  version = var.k8s_version

  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids          = data.aws_ssm_parameter.private_subnets[*].value
    public_access_cidrs = var.api_public_access_cidrs
  }

  encryption_config {
    provider {
      key_arn = aws_kms_key.main.arn
    }
    resources = ["secrets"]
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP" # compatible mode ( best pratice is using API )
    bootstrap_cluster_creator_admin_permissions = true
  }

  enabled_cluster_log_types = [
    "api", "audit", "authenticator", "controllerManager", "scheduler"
  ]

  zonal_shift_config {
    enabled = true
  }

  tags = merge(
    {
      Name                                        = var.project_name,
      "kubernetes.io/cluster/${var.project_name}" = "shared"
    },
    var.common_tags
  )

}