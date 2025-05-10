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

variable "route53" {
  type = object({
    dns_name    = string
    hosted_zone = string
  })
  description = "Route53 dns name and hosted zone"
}

variable "alb_public_access_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks that can access the shared load balancer"
  default     = ["0.0.0.0/0"]
}

variable "routing_weight" {
  type = object({
    cluster_01 = number
    cluster_02 = number
  })
  description = "The shared load balancer traffic split"
}
