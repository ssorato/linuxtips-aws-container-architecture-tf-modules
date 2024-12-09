resource "aws_cloudwatch_log_group" "main" {
  name              = format("%s/%s/logs", var.ecs_name, var.ecs_service_name)
  retention_in_days = var.cloudwatch_log_retention_in_days

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

  alarm_name = format("ecs-%s-%s-cpu-scale-in", var.project_name, var.ecs_service_name)

  comparison_operator = var.cloudwatch_scale.in_comparison_operator

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

#
# CodeDeploy
#
resource "aws_cloudwatch_metric_alarm" "rollback_alarm" {
  count = (var.deployment_controller == "CODE_DEPLOY" && var.codedeploy_rollback_alarm) ? 1 : 0

  alarm_name = format("%s-error-rate", aws_codedeploy_app.main[count.index].name)

  comparison_operator = "GreaterThanOrEqualToThreshold"

  evaluation_periods = var.codedeploy_rollback_error_evaluation_period
  threshold          = var.codedeploy_rollback_error_threshold

  metric_query {
    id         = "error_rate"
    expression = "(errBlue + errGreen) / (rqBlue + rqGreen) * 100"
    label      = "Error Rate"

    return_data = true
  }

  metric_query {
    id = "rqBlue"

    metric {
      metric_name = "RequestCount"
      namespace   = "AWS/ApplicationELB"
      period      = var.codedeploy_rollback_error_period
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = data.aws_alb.main[count.index].arn_suffix
        TargetGroup  = aws_alb_target_group.blue[count.index].arn_suffix
      }
    }
  }

  metric_query {
    id = "rqGreen"

    metric {
      metric_name = "RequestCount"
      namespace   = "AWS/ApplicationELB"
      period      = var.codedeploy_rollback_error_period
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = data.aws_alb.main[count.index].arn_suffix
        TargetGroup  = aws_alb_target_group.green[count.index].arn_suffix
      }
    }
  }

  metric_query {
    id = "errBlue"

    metric {
      metric_name = "HTTPCode_Target_5XX_Count"
      namespace   = "AWS/ApplicationELB"
      period      = var.codedeploy_rollback_error_period
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = data.aws_alb.main[count.index].arn_suffix
        TargetGroup  = aws_alb_target_group.blue[count.index].arn_suffix
      }
    }
  }

  metric_query {
    id = "errGreen"

    metric {
      metric_name = "HTTPCode_Target_5XX_Count"
      namespace   = "AWS/ApplicationELB"
      period      = var.codedeploy_rollback_error_period
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = data.aws_alb.main[count.index].arn_suffix
        TargetGroup  = aws_alb_target_group.green[count.index].arn_suffix
      }
    }
  }

  tags = merge(
    {
      Name = format("%s-error-rate", aws_codedeploy_app.main[count.index].name)
    },
    var.common_tags
  )
}