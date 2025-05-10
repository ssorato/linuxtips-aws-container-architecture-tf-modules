resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.cluster_01.arn
        weight = lookup(var.routing_weight, "cluster_01")
      }
      target_group {
        arn    = aws_lb_target_group.cluster_02.arn
        weight = lookup(var.routing_weight, "cluster_02")
      }
    }
  }

  tags = merge(
    {
      Name = format("%s-http-listener", var.project_name)
    },
    var.common_tags
  )
}


resource "aws_lb_listener" "https" {
  count             = var.route53.dns_name == "" || var.route53.hosted_zone == "" ? 0 : 1
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy = "ELBSecurityPolicy-2016-08"

  certificate_arn = aws_acm_certificate.main[0].arn

  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.cluster_01.arn
        weight = lookup(var.routing_weight, "cluster_01")
      }
      target_group {
        arn    = aws_lb_target_group.cluster_02.arn
        weight = lookup(var.routing_weight, "cluster_02")
      }
    }
  }

  tags = merge(
    {
      Name = format("%s-https-listener", var.project_name)
    },
    var.common_tags
  )
}