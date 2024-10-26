resource "aws_ecs_task_definition" "main" {
  family = format("%s-%s-task-%s", var.ecs_name, var.ecs_service_name, var.project_name)

  network_mode = "awsvpc"

  requires_compatibilities = var.capabilities

  cpu    = var.ecs_service_cpu
  memory = var.ecs_service_memory_mb

  execution_role_arn = aws_iam_role.service_execution_role.arn
  task_role_arn      = var.service_task_execution_role_arn

  # EFS volume
  dynamic "volume" {
    for_each = var.efs_volumes

    content {
      name = volume.value.volume_name

      efs_volume_configuration {
        file_system_id     = volume.value.file_system_id
        root_directory     = volume.value.file_system_root
        transit_encryption = "ENABLED"
      }
    }
  }

  # Using the same cpu and memory size in the task definition as we are only using one container
  container_definitions = jsonencode([
    {
      name   = var.ecs_service_name
      image  = var.container_image
      cpu    = var.ecs_service_cpu
      memory = var.ecs_service_memory_mb

      essential = true

      portMappings = [
        {
          name          = var.ecs_service_name
          containerPort = var.ecs_service_port
          hostPort      = var.ecs_service_port
          protocol      = var.protocol
          appProtocol   = var.service_protocol
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.main.id
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = var.ecs_service_name
        }
      }

      # EFS mountpoints
      mountPoints = [
        for volume in var.efs_volumes : {
          sourceVolume  = volume.volume_name
          containerPath = volume.mount_point
          readOnly      = volume.read_only
        }
      ]

      environment = var.environment_variables
      secrets     = var.secrets

    }
  ])

  tags = merge(
    {
      Name = format("%s-%s-task-%s", var.ecs_name, var.ecs_service_name, var.project_name)
    },
    var.common_tags
  )
}