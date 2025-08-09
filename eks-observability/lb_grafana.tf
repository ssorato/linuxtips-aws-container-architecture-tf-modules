resource "aws_lb" "grafana" {

  name = format("%s-grafana", var.project_name)

  internal           = false
  load_balancer_type = "application"

  subnets = data.aws_ssm_parameter.public_subnets[*].value

  security_groups = [aws_security_group.grafana.id]

  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = false

  tags = merge(
    {
      Name = format("%s-grafana", var.project_name)
    },
    var.common_tags
  )

}

resource "aws_lb_target_group" "grafana" {
  name     = format("%s-grafana", var.project_name)
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc.value

  health_check {
    matcher = "200-299"
    path    = "/healthz"
  }
}

resource "aws_lb_listener" "grafana_http" {
  load_balancer_arn = aws_lb.grafana.arn
  port              = 80
  protocol          = "HTTP"

  # default_action {
  #   type             = "forward"
  #   target_group_arn = aws_lb_target_group.grafana.arn
  # }

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = merge(
    {
      Name = format("%s-http-grafana-listner", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_lb_listener" "grafana_https" {
  count = var.route53.dns_name == "" || var.route53.hosted_zone == "" ? 0 : 1

  load_balancer_arn = aws_lb.grafana.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana.arn
  }

  tags = merge(
    {
      Name = format("%s-https-grafana-listner", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_security_group" "grafana" {
  name = format("%s-grafana", var.project_name)

  vpc_id = data.aws_ssm_parameter.vpc.value

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.alb_public_access_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = format("%s-grafana", var.project_name)
    },
    var.common_tags
  )
}

resource "kubectl_manifest" "grafana" {
  yaml_body = <<YAML
apiVersion: elbv2.k8s.aws/v1beta1
kind: TargetGroupBinding
metadata:
  name: grafana
  namespace: grafana
spec:
  serviceRef:
    name: grafana
    port: 80
  targetGroupARN: ${aws_lb_target_group.grafana.arn}
  targetType: instance
YAML
  depends_on = [
    helm_release.grafana
  ]
}
