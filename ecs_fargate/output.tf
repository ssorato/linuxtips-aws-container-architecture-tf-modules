output "ecs_alb_dns_name" {
  value       = aws_lb.ecs_alb.dns_name
  description = "The ECS ALB dns name"
}

output "ecs_alb_internal_dns_name" {
  value       = aws_lb.ecs_alb_internal.dns_name
  description = "The ECS ALB internal dns name"
}

output "ssm_alb_arn" {
  value       = aws_ssm_parameter.alb_arn.id
  description = "AWS SSM parameter store ALB arn"
  sensitive   = false
}

output "ssm_alb_internal_arn" {
  value       = aws_ssm_parameter.alb_internal_arn.id
  description = "AWS SSM parameter store ALB internal arn"
  sensitive   = false
}

output "ssm_alb_internal_listener_arn" {
  value       = aws_ssm_parameter.alb_internal_listener_arn.id
  description = "AWS SSM parameter store ALB internal listner arn"
  sensitive   = false
}

output "ssm_cloudmap" {
  value       = aws_ssm_parameter.cloudmap.id
  description = "AWS SSM parameter store Service Discovery Namespace id"
  sensitive   = false
}
