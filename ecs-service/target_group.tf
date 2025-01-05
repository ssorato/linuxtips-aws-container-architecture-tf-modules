resource "aws_alb_target_group" "main" {
  count = (var.use_lb && var.deployment_controller == "ECS") ? 1 : 0
  #name  = substr(sha256(format("%s%s", var.ecs_service_name, var.ecs_name)), 0, 32)
  name_prefix = substr(var.ecs_service_name, 0, 6)

  port   = var.ecs_service_port
  vpc_id = var.vpc_id

  protocol    = "HTTP"
  target_type = "ip"

  health_check {
    healthy_threshold   = lookup(var.service_healthcheck, "healthy_threshold", "3")
    unhealthy_threshold = lookup(var.service_healthcheck, "unhealthy_threshold", "10")
    timeout             = lookup(var.service_healthcheck, "timeout", "10")
    interval            = lookup(var.service_healthcheck, "interval", "10")
    matcher             = lookup(var.service_healthcheck, "matcher", "200")
    path                = lookup(var.service_healthcheck, "path", "/")
    port                = lookup(var.service_healthcheck, "port", var.ecs_service_port)
  }

  lifecycle {
    create_before_destroy = false
  }

  tags = merge(
    {
      Name = substr(sha256(format("%s%s", var.ecs_service_name, var.ecs_name)), 0, 32)
    },
    var.common_tags
  )
}

#
# Blue / Green deployment with CodeDeploy
#
resource "aws_alb_target_group" "blue" {
  count  = (var.use_lb && var.deployment_controller == "CODE_DEPLOY") ? 1 : 0
  name   = substr(sha256(format("blue-%s%s", var.ecs_service_name, var.ecs_name)), 0, 32)
  port   = var.ecs_service_port
  vpc_id = var.vpc_id

  protocol    = "HTTP"
  target_type = "ip"

  health_check {
    healthy_threshold   = lookup(var.service_healthcheck, "healthy_threshold", "3")
    unhealthy_threshold = lookup(var.service_healthcheck, "unhealthy_threshold", "10")
    timeout             = lookup(var.service_healthcheck, "timeout", "10")
    interval            = lookup(var.service_healthcheck, "interval", "10")
    matcher             = lookup(var.service_healthcheck, "matcher", "200")
    path                = lookup(var.service_healthcheck, "path", "/")
    port                = lookup(var.service_healthcheck, "port", var.ecs_service_port)
  }

  lifecycle {
    create_before_destroy = false
  }

  tags = merge(
    {
      Name = format("blue-%s%s", var.ecs_service_name, var.ecs_name)
    },
    var.common_tags
  )
}

resource "aws_alb_target_group" "green" {
  count  = (var.use_lb && var.deployment_controller == "CODE_DEPLOY") ? 1 : 0
  name   = substr(sha256(format("green-%s%s", var.ecs_service_name, var.ecs_name)), 0, 32)
  port   = var.ecs_service_port
  vpc_id = var.vpc_id

  protocol    = "HTTP"
  target_type = "ip"

  health_check {
    healthy_threshold   = lookup(var.service_healthcheck, "healthy_threshold", "3")
    unhealthy_threshold = lookup(var.service_healthcheck, "unhealthy_threshold", "10")
    timeout             = lookup(var.service_healthcheck, "timeout", "10")
    interval            = lookup(var.service_healthcheck, "interval", "10")
    matcher             = lookup(var.service_healthcheck, "matcher", "200")
    path                = lookup(var.service_healthcheck, "path", "/")
    port                = lookup(var.service_healthcheck, "port", var.ecs_service_port)
  }

  lifecycle {
    create_before_destroy = false
  }

  tags = merge(
    {
      Name = format("green-%s%s", var.ecs_service_name, var.ecs_name)
    },
    var.common_tags
  )
}
