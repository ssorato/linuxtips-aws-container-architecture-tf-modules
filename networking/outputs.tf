output "vpc_id" {
  value       = aws_ssm_parameter.vpc.id
  description = "SSM Parameter about vpc id"
}

output "public_subnets" {
  value       = aws_ssm_parameter.public_subnets[*].id
  description = "SSM Parameters about public subnets id"
}

output "private_subnets" {
  value       = aws_ssm_parameter.private_subnets[*].id
  description = "SSM Parameters about private subnets id"
}

output "database_subnets" {
  value       = aws_ssm_parameter.databases_subnets[*].id
  description = "SSM Parameters about database subnets id"
}
