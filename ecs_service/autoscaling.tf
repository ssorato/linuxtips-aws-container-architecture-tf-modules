resource "aws_appautoscaling_target" "ecs" {
  max_capacity = var.common_scale.task_maximum
  min_capacity = var.common_scale.task_minimum

  resource_id        = "service/${format("ecs-%s", var.project_name)}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "cpu_high" {
  count = var.common_scale.scale_type == "cpu" ? 1 : 0

  resource_id        = aws_appautoscaling_target.ecs.resource_id
  service_namespace  = aws_appautoscaling_target.ecs.service_namespace
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension

  name = format("%s-%s-cpu-scale-out", var.project_name, var.ecs_service_name)

  policy_type = "StepScaling"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.common_scale.out_cooldown
    metric_aggregation_type = var.cloudwatch_scale.out_statistic

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = var.cloudwatch_scale.out_adjustment
    }
  }
}

resource "aws_appautoscaling_policy" "cpu_low" {
  count = var.common_scale.scale_type == "cpu" ? 1 : 0

  resource_id        = aws_appautoscaling_target.ecs.resource_id
  service_namespace  = aws_appautoscaling_target.ecs.service_namespace
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension

  name = format("%s-%s-cpu-scale-in", var.project_name, var.ecs_service_name)

  policy_type = "StepScaling"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.common_scale.in_cooldown
    metric_aggregation_type = var.cloudwatch_scale.in_statistic

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = var.cloudwatch_scale.in_adjustment
    }

    step_adjustment {
      metric_interval_lower_bound = 0
      metric_interval_upper_bound = var.cloudwatch_scale.in_cpu_threshold
      scaling_adjustment          = var.cloudwatch_scale.in_adjustment
    }

    step_adjustment {
      metric_interval_lower_bound = var.cloudwatch_scale.in_cpu_threshold
      scaling_adjustment          = 0
    }
  }
}
