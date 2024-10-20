variable "common_tags" {
  type        = map(string)
  description = "Common tags"
}

variable "project_name" {
  type        = string
  description = "The resource name sufix"
}

variable "aws_region" {
  type        = string
  description = "The AWS region"
  default     = "us-east-1"
}

variable "ssm_vpc_id" {
  type        = string
  description = "The VPC id in the AWS Systems Manager Parameter Store"
}

variable "ssm_private_subnet_list" {
  type        = list(string)
  description = "A list of private subnet id in the AWS Systems Manager Parameter Store"
  validation {
    condition     = length(var.ssm_private_subnet_list) > 0
    error_message = "Needs at least one private subnet"
  }
}

variable "ssm_public_subnet_list" {
  type        = list(string)
  description = "A list of public subnet id in the AWS Systems Manager Parameter Store"
  validation {
    condition     = length(var.ssm_public_subnet_list) > 0
    error_message = "Needs at least one public subnet"
  }
}

variable "alb_ingress_cidr_enabled" {
  type        = list(string)
  description = "A list of CIDR enabled to access the ALB"
  default     = ["0.0.0.0/0"]
  validation {
    condition     = length(var.alb_ingress_cidr_enabled) > 0
    error_message = "Needs at least one CIDR"
  }
}

variable "capacity_providers" {
  type        = list(string)
  description = "A list of capacity providers used by ECS with Fargate"
  default     = ["FARGATE", "FARGATE_SPOT"]
}