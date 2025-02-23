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

variable "addon_cni_version" {
  type        = string
  description = "VPC CNI addon version"
  default     = "v1.18.3-eksbuild.2"
}

variable "addon_coredns_version" {
  type        = string
  description = "CoreDNS addon version"
  default     = "v1.11.3-eksbuild.1"
}

variable "addon_kubeproxy_version" {
  type        = string
  description = "Kube-Proxy addon version"
  default     = "v1.31.2-eksbuild.3"
}

variable "metrics_server_version" {
  type        = string
  description = "The metric server version"
  default     = "7.2.16"
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

variable "route53" {
  type = object({
    dns_name    = string
    hosted_zone = string
  })
  description = "Route53 dns name and hosted zone"
}

variable "ingress_nlb" {
  type = object({
    create        = bool
    ingress_type  = optional(string, "")
    inbound_cidrs = optional(list(string), ["0.0.0.0/0"])
  })
  description = "Create a NLB used by ingress controller and TargetGroupBinding"
  default = {
    create = false
  }
  validation {
    condition     = var.ingress_nlb.create == true && contains(["nginx", "traefik"], var.ingress_nlb.ingress_type)
    error_message = "NBL ingress destination can be 'nginx' (Nginx Ingress Controller) or 'traefik' (Traefik Kubernetes Ingress)"
  }
}

#
# Usign autoscaling
variable "ingress_controller_config" {
  type = object({
    kind            = optional(string, "Deployment")
    min_replicas    = number
    max_replicas    = number
    requests_cpu    = string
    requests_memory = string
    limits_cpu      = string
    limits_memory   = string
    fargate_ns      = optional(string, "")
  })
  description = "Ingress Controller configurations"
}