resource "aws_route53_zone" "private" {
  name = format("%s.internal.com", var.project_name)

  vpc {
    vpc_id = data.aws_ssm_parameter.vpc.value
  }

  tags = merge(
    {
      Name = format("%s.internal.com", var.project_name)
    },
    var.common_tags
  )
}

# Internal zone used with internal ALB
resource "aws_route53_record" "wildcard" {
  zone_id = aws_route53_zone.private.zone_id
  name    = format("*.%s.internal.com", var.project_name)
  type    = "A"

  alias {
    name                   = aws_lb.ecs_alb_internal.dns_name
    zone_id                = aws_lb.ecs_alb_internal.zone_id
    evaluate_target_health = true
  }
}

# Service discovery zone
resource "aws_service_discovery_private_dns_namespace" "main" {
  name        = format("%s.discovery.com", var.project_name)
  description = "Service Discovery usede in ECS cluster"
  vpc         = data.aws_ssm_parameter.vpc.value

  tags = merge(
    {
      Name = format("%s.discovery.com", var.project_name)
    },
    var.common_tags
  )
}

