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

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  deployment_circuit_breaker {
    enable   = true
    rollback = true
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

  load_balancer {
    target_group_arn = aws_alb_target_group.main.arn
    container_name   = var.ecs_service_name
    container_port   = var.ecs_service_port
  }

  lifecycle {
    ignore_changes = [
      desired_count
    ]
  }

  tags = merge(
    {
      Name = var.ecs_service_name
    },
    var.common_tags
  )

}