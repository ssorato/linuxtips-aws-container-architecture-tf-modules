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

variable "vpc_cidr" {
  type        = string
  description = "The main VPC CIDR"
}

variable "vpc_additional_cidrs" {
  type        = list(string)
  description = "Additional VPC CIDR's list"
  default     = []
}

variable "public_subnets" {
  type = list(object({
    name              = string
    cidr              = string
    availability_zone = string
  }))
  description = "The public subnet CIDR"
}

variable "private_subnets" {
  type = list(object({
    name              = string
    cidr              = string
    availability_zone = string
  }))
  description = "The private subnet CIDR"
}

variable "database_subnets" {
  type = list(object({
    name              = string
    cidr              = string
    availability_zone = string
  }))
  description = "The databases subnet CIDR"
  default     = []
}

# This is a point of failure
# Saving money using one nat gateway
variable "unique_natgw" {
  type        = bool
  description = "Just to reduce costs .. create a single NAT gw for all private subnets"
  default     = true
}

# Netowrk ACLs used in database subnet
variable "database_nacl_rules" {
  type = list(object({
    rule_start_number = number
    rule_action       = string
    protocol          = string
    from_port         = optional(number)
    to_port           = optional(number)
  }))
  description = "A map of network ACLs rules in the database subnet"
  default     = []
}

