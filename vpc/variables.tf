variable "common_tags" {
  type        = map(string)
  description = "Common tags"
}

variable "project_name" {
  type        = string
  description = "The resource name sufix"
}

variable "vpc_cidr" {
  type        = string
  description = "The VPC CIDR"
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "The VPC must be a valid IPv4 CIDR."
  }
}

variable "private_subnets" {
  type = list(object({
    name              = string
    cidr              = string
    availability_zone = string
  }))
  description = "The private subnets"
  validation {
    condition = length(var.private_subnets) > 0 && alltrue([
      for subnet in var.private_subnets : can(cidrhost(subnet.cidr, 0))
    ])
    error_message = "Needs at least one private subnet and it must be a valid IPv4 CIDR."
  }
}

# This is a point of failure
# Saving money using one nat gateway
variable "unique_natgw" {
  type        = bool
  description = "Just to reduce costs .. create a single NAT gw for all private subnets"
  default     = true
}

variable "public_subnets" {
  type = list(object({
    name              = string
    cidr              = string
    availability_zone = string
  }))
  description = "The public subnets"
  validation {
    condition = length(var.public_subnets) > 0 && alltrue([
      for subnet in var.public_subnets : can(cidrhost(subnet.cidr, 0))
    ])
    error_message = "Needs at least one public subnet and it must be a valid IPv4 CIDR."
  }
}