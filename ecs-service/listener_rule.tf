resource "aws_alb_listener_rule" "main" {
  count = (var.use_lb && var.deployment_controller == "ECS") ? 1 : 0

  listener_arn = var.alb_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.main[0].arn
  }

  condition {
    host_header {
      values = var.service_hosts
    }
  }

  lifecycle {
    replace_triggered_by = [aws_alb_target_group.main]
  }

  tags = var.common_tags
}

resource "aws_alb_listener_rule" "main_https" {
  count = (var.use_lb && var.deployment_controller == "ECS") ? 1 : 0

  listener_arn = var.alb_listener_https_arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.main[0].arn
  }

  condition {
    host_header {
      values = var.service_hosts
    }
  }

  tags = var.common_tags
}

#
# Deployment with CodeDeploy
#
resource "aws_alb_listener_rule" "codedeploy" {
  count        = (var.use_lb && var.deployment_controller == "CODE_DEPLOY") ? 1 : 0
  listener_arn = var.alb_listener_arn

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_alb_target_group.blue[count.index].arn
        weight = 100
      }

      target_group {
        arn    = aws_alb_target_group.green[count.index].arn
        weight = 0
      }

    }
  }

  condition {
    host_header {
      values = var.service_hosts
    }
  }

  lifecycle {
    ignore_changes = [
      action
    ]
  }

  tags = var.common_tags
}