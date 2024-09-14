resource "aws_cloudwatch_log_group" "main" {
  name = format("%s/%s/logs", var.ecs_name, var.ecs_service_name)

  tags = merge(
    {
      Name = format("%s/%s/logs", var.ecs_name, var.ecs_service_name)
    },
    var.common_tags
  )
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  count = var.common_scale.scale_type == "cpu" ? 1 : 0

  alarm_name = format("ecs-%s-%s-cpu-scale-out", var.project_name, var.ecs_service_name)

  comparison_operator = var.cloudwatch_scale.out_comparison_operator

  metric_name = "CPUUtilization"
  namespace   = "AWS/ECS"
  statistic   = var.cloudwatch_scale.out_statistic

  period             = var.cloudwatch_scale.out_period
  evaluation_periods = var.cloudwatch_scale.out_evaluation_periods
  threshold          = var.cloudwatch_scale.out_cpu_threshold

  dimensions = {
    ClusterName = format("ecs-%s", var.project_name)
    ServiceName = var.ecs_service_name
  }

  alarm_actions = [
    aws_appautoscaling_policy.cpu_high[count.index].arn
  ]

  tags = merge(
    {
      Name = format("ecs-%s-%s-cpu-scale-out", var.project_name, var.ecs_service_name)
    },
    var.common_tags
  )
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  count = var.common_scale.scale_type == "cpu" ? 1 : 0

  alarm_name = format("ecs-%s-%s-cpu-scale-out", var.project_name, var.ecs_service_name)

  comparison_operator = var.cloudwatch_scale.out_comparison_operator

  metric_name = "CPUUtilization"
  namespace   = "AWS/ECS"
  statistic   = var.cloudwatch_scale.in_statistic

  period             = var.cloudwatch_scale.in_period
  evaluation_periods = var.cloudwatch_scale.in_evaluation_periods
  threshold          = var.cloudwatch_scale.in_cpu_threshold

  dimensions = {
    ClusterName = format("ecs-%s", var.project_name)
    ServiceName = var.ecs_service_name
  }

  alarm_actions = [
    aws_appautoscaling_policy.cpu_low[count.index].arn
  ]

  tags = merge(
    {
      Name = format("ecs-%s-%s-cpu-scale-in", var.project_name, var.ecs_service_name)
    },
    var.common_tags
  )
}

