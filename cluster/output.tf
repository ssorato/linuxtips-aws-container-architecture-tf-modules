output "cluster_name" {
  value       = aws_ecs_cluster.main.name
  description = "The ECS cluster name"
}

output "internal_load_balancer_dns" {
  value       = aws_lb.internal.dns_name
  description = "The internal load balancer dns name"
}

output "lb_internal_arn" {
  value       = aws_lb.internal.arn
  description = "The internal load balancer arn"
}

output "lb_internal_listener" {
  value       = aws_lb_listener.internal.arn
  description = "The internal load balancer listner arn"
}

output "lb_internal_listener_https" {
  value       = length(var.acm_certs) > 0 ? aws_lb_listener.internal_443[0].arn : aws_lb_listener.internal.arn
  description = "The internal load balancer HTTPs listner arn or HTTP listner arn when no certificates are used"
}

output "service_discovery_cloudmap" {
  value       = aws_service_discovery_private_dns_namespace.main.id
  description = "The AWS service discovery private dns namespace id"
}

output "service_discovery_cloudmap_name" {
  value       = aws_service_discovery_private_dns_namespace.main.name
  description = "The AWS service discovery private dns namespace name"
}

output "service_discovery_service_connect" {
  value       = aws_service_discovery_private_dns_namespace.sc.id
  description = "The AWS service conect private dns namespace id"
}

output "service_discovery_service_connect_name" {
  value       = aws_service_discovery_private_dns_namespace.sc.name
  description = "The AWS service conect private dns namespace name"
}

output "vpc_link_nlb_arn" {
  value       = aws_lb.vpclink.arn
  description = "The network load balancer VPC link arn"
}

output "vpc_link" {
  value       = aws_api_gateway_vpc_link.main.id
  description = "The VPC link id"
}
