variable "common_tags" {
  type        = map(string)
  description = "Common tags"
}

variable "project_name" {
  type        = string
  description = "The resource name sufix"
}

variable "region" {
  type        = string
  description = "The AWS region"
}

variable "ssm_vpc" {
  type        = string
  description = "The main VPC from AWS SSM parameters"
}

variable "ssm_public_subnets" {
  type        = list(string)
  description = "Public subnets from AWS SSM parameters"
}

variable "ssm_private_subnets" {
  type        = list(string)
  description = "Private subnets from AWS SSM parameters"
}

variable "ssm_pod_subnets" {
  type        = list(string)
  description = "PODs subnets from AWS SSM parameters"
}

variable "ssm_natgw_eips" {
  type        = list(string)
  description = "NAT gw EIP from AWS SSM parameters"
}

variable "k8s_version" {
  type        = string
  description = "The kubernetes version"
}

variable "api_public_access_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks that can access the Amazon EKS public API server endpoint when enabled"
  default     = ["0.0.0.0/0"]
}

variable "eks_oidc_thumbprint" {
  type        = string
  description = "Thumbprint of Root CA for EKS OIDC"
  default     = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
}

variable "auto_scale_options" {
  type = object({
    min     = number
    max     = number
    desired = number
  })
  description = "Cluster autoscaling configurations"
}
