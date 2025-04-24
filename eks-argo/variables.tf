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

variable "addon_pod_identity_version" {
  type        = string
  description = "POD identity addon version"
  default     = "v1.3.4-eksbuild.1"
}

variable "addon_efs_csi_version" {
  type        = string
  description = "EFS addon version"
  default     = "v2.1.4-eksbuild.1"
}

# aws eks describe-addon-versions --kubernetes-version=1.31 \
# --addon-name aws-mountpoint-s3-csi-driver \
# --query='addons[].addonVersions[].addonVersion' | jq '.[0]'
variable "addon_s3_csi_version" {
  type        = string
  description = "S3 CIS addon version"
  default     = "v1.13.0-eksbuild.1"
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

variable "istio_config" {
  type = object({
    version       = string
    min_replicas  = number
    cpu_threshold = number
  })
  description = "Istio Ingress Controller configurations"
}

variable "ingress_inbound_cidrs" {
  type        = list(string)
  description = "CIDRs access to the NLB used by ingress controller and TargetGroupBinding"
  default     = ["0.0.0.0/0"]
}

variable "node_group" {
  type = map(object({
    capacity_type  = string
    ami_type       = optional(string, null)
    labels         = map(string)
    instance_sizes = list(string)
    volume_size    = optional(number, 20)
    min            = number
    max            = number
    desired        = number
  }))
  description = "Cluster node group and autoscaling configurations"
}

variable "grafana_host" {
  type        = string
  description = "Grafana host"
}

variable "jaeger_host" {
  type        = string
  description = "Jaeger host"
}

variable "kiali_host" {
  type        = string
  description = "Kiali host"
}

variable "kiali_version" {
  type        = string
  description = "The Kiali version"
  default     = "2.5"
}

variable "keda_version" {
  type        = string
  description = "The Keda version"
  default     = "2.16.0"
}

variable "argo_rollouts_version" {
  type        = string
  description = "Argo Rollouts version"
  default     = "2.34.1"
}

variable "argo_rollouts_host" {
  type        = string
  description = "Argo Rollouts host"
}