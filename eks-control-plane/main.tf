module "eks-control-plane" {
  source = "../eks"

  common_tags         = var.common_tags
  project_name        = var.project_name
  region              = var.region
  ssm_vpc             = var.ssm_vpc
  ssm_private_subnets = var.ssm_private_subnets
  ssm_pod_subnets     = var.ssm_pod_subnets
  ssm_natgw_eips      = var.ssm_natgw_eips

  eks_api_public_access_cidrs = var.eks_api_public_access_cidrs

  karpenter_capacity = var.karpenter_capacity

  enable_istio = false

}
