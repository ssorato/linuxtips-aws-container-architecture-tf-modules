resource "aws_ecs_service" "main" {
  name            = var.ecs_service_name
  cluster         = var.ecs_name
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.common_scale.task_desired

  # Cloud Map
  dynamic "service_registries" {
    for_each = var.service_discovery_namespace != null ? [var.ecs_service_name] : []
    content {
      registry_arn   = aws_service_discovery_service.main[0].arn
      container_name = service_registries.value
    }
  }

  # Service Connect
  dynamic "service_connect_configuration" {
    for_each = var.use_service_connect ? [var.service_connect_name] : []

    content {
      enabled   = var.deployment_controller == "CODE_DEPLOY" ? false : var.use_service_connect
      namespace = var.service_connect_name

      service {
        port_name      = var.ecs_service_name
        discovery_name = var.ecs_service_name

        client_alias {
          port     = var.ecs_service_port
          dns_name = format("%s.%s", var.ecs_service_name, var.service_connect_name)
        }
      }

    }
  }

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  deployment_controller {
    type = var.deployment_controller
  }

  # Only used when ECS deployment controller
  deployment_circuit_breaker {
    enable   = var.deployment_controller == "ECS" ? true : false
    rollback = var.deployment_controller == "ECS" ? true : false
  }

  # Only used when is EC2
  dynamic "ordered_placement_strategy" {
    for_each = var.service_launch_type == "EC2" ? [1] : []
    content {
      type  = "spread"
      field = "attribute:ecs.availability-zone"
    }
  }

  dynamic "capacity_provider_strategy" {
    for_each = var.service_launch_type

    content {
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      weight            = capacity_provider_strategy.value.weight
    }
  }


  network_configuration {
    security_groups = [
      aws_security_group.main.id
    ]

    subnets          = var.private_subnets
    assign_public_ip = false
  }

  dynamic "load_balancer" {
    for_each = var.use_lb ? [1] : []

    content {
      target_group_arn = (var.use_lb && var.deployment_controller == "CODE_DEPLOY") ? aws_alb_target_group.blue[0].arn : aws_alb_target_group.main[0].arn
      container_name   = var.ecs_service_name
      container_port   = var.ecs_service_port
    }

  }

  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition, # due to CodeDeploy
      load_balancer    # due to CodeDeploy
    ]
  }

  tags = merge(
    {
      Name = var.ecs_service_name
    },
    var.common_tags
  )

}