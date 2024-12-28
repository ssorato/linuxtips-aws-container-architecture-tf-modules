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

variable "vpc_id" {
  description = "The VPC id"
  type        = string
}

variable "private_subnets" {
  type        = list(string)
  description = "A list of private subnet id"
  validation {
    condition     = length(var.private_subnets) > 0
    error_message = "Needs at least one private subnet"
  }
}

variable "public_subnets" {
  type        = list(string)
  description = "A list of public subnet id"
  validation {
    condition     = length(var.public_subnets) > 0
    error_message = "Needs at least one public subnet"
  }
}

variable "capacity_providers" {
  type        = list(string)
  description = "A list of capacity providers used by ECS with Fargate"
  default     = ["FARGATE", "FARGATE_SPOT"]
}

variable "acm_certs" {
  type        = list(string)
  description = "ARNs list about ACM certificates"
  default     = []
}
