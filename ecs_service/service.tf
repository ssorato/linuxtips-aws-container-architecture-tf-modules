resource "aws_ecs_service" "main" {
  name            = var.ecs_service_name
  cluster         = var.ecs_name
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.common_scale.task_desired
  launch_type     = var.service_launch_type

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
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