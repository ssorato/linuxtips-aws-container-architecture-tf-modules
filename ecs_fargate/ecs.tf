resource "aws_ecs_cluster" "main" {
  name = format("ecs-%s", var.project_name)

  setting {
    name  = "containerInsights" # ECS Container Insights metrics
    value = "enabled"
  }

  tags = merge(
    {
      Name = format("ecs-%s", var.project_name)
    },
    var.common_tags
  )
}
