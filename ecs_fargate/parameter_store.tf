resource "aws_ssm_parameter" "alb_arn" {
  name  = format("/%s/ecs/lb/arn", var.project_name)
  value = aws_lb.ecs_alb.arn
  type  = "String"

  tags = merge(
    {
      Name = format("/%s/ecs/lb/arn", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_ssm_parameter" "alb_listener_arn" {
  name  = format("/%s/ecs/lb/listerner/arn", var.project_name)
  value = aws_lb_listener.ecs_alb.arn
  type  = "String"

  tags = merge(
    {
      Name = format("/%s/ecs/lb/listerner/arn", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_ssm_parameter" "alb_internal_arn" {
  name  = format("/%s/ecs/lb/internal/arn", var.project_name)
  value = aws_lb.ecs_alb_internal.arn
  type  = "String"

  tags = merge(
    {
      Name = format("/%s/ecs/lb/internal/arn", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_ssm_parameter" "alb_internal_listener_arn" {
  name  = format("/%s/ecs/lb/internal/listerner/arn", var.project_name)
  value = aws_lb_listener.ecs_alb_internal.arn
  type  = "String"

  tags = merge(
    {
      Name = format("/%s/ecs/lb/internal/listerner/arn", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_ssm_parameter" "cloudmap" {
  name  = format("/%s/ecs/cloudmap/namespace", var.project_name)
  value = aws_service_discovery_private_dns_namespace.main.id
  type  = "String"

  tags = merge(
    {
      Name = format("/%s/ecs/cloudmap/namespace", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_ssm_parameter" "service_connect" {
  name  = format("/%s/ecs/service-connect/namespace", var.project_name)
  value = aws_service_discovery_private_dns_namespace.sc.id
  type  = "String"

  tags = merge(
    {
      Name = format("/%s/ecs/service-connect/namespace", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_ssm_parameter" "service_connect_name" {
  name  = format("/%s/ecs/service-connect/name", var.project_name)
  value = aws_service_discovery_private_dns_namespace.sc.name
  type  = "String"

  tags = merge(
    {
      Name = format("/%s/ecs/service-connect/name", var.project_name)
    },
    var.common_tags
  )
}
