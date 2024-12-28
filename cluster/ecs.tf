resource "aws_ecs_cluster" "main" {
  name = format("%s", var.project_name)

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(
    {
      Name = format("%s", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = var.capacity_providers

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}
