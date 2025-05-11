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
  default     = "1.32"
}

variable "eks_api_public_access_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks that can access the Amazon EKS public API server endpoint when enabled"
  default     = ["0.0.0.0/0"]
}

variable "node_group_temp" {
  type = object({
    instances_size = list(string)
    desired_size   = number
    max_size       = number
    min_size       = number
  })
  description = "Temporary node group"
  default = {
    instances_size = ["t3a.medium"]
    desired_size   = 2
    max_size       = 2
    min_size       = 2
  }
}

variable "karpenter_capacity" {
  type = list(object({
    name               = string
    workload           = string
    ami_family         = string
    ami_ssm            = string
    instance_family    = list(string)
    instance_sizes     = list(string)
    capacity_type      = list(string)
    availability_zones = list(string)
  }))
}

variable "enable_istio" {
  type        = bool
  description = "Enable Istio installation"
  default     = true
}

variable "istio_config" {
  type = object({
    version       = string
    min_replicas  = number
    cpu_threshold = number
  })
  description = "Istio Ingress Controller configurations"
  default = {
    version       = "1.25.0"
    min_replicas  = 3
    cpu_threshold = 60
  }
}

variable "istio_ssm_target_group" {
  type        = string
  description = "The shared load balancer targer group from AWS SSM parameters"
  default     = ""
}
