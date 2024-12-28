output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The VPC id"
}

output "public_subnets" {
  value       = aws_subnet.public[*].id
  description = "The public subnets id"
}

output "private_subnets" {
  value       = aws_subnet.private[*].id
  description = "The private subnets id"
}
