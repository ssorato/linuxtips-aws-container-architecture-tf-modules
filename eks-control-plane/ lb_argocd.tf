resource "aws_lb" "main" {
  name               = var.project_name
  internal           = false
  load_balancer_type = "application"

  subnets = data.aws_ssm_parameter.lb_subnets[*].value

  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = false

  security_groups = [
    aws_security_group.main.id
  ]

  tags = merge(
    {
      Name = var.project_name
    },
    var.common_tags
  )

}

resource "aws_lb_target_group" "argo" {
  name     = var.project_name
  port     = 30080
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc.value

  health_check {
    path    = "/"
    matcher = "200-404"
  }

  tags = merge(
    {
      Name = var.project_name
    },
    var.common_tags
  )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn = aws_lb_target_group.argo.arn
      }
    }
  }

  tags = merge(
    {
      Name = var.project_name
    },
    var.common_tags
  )
}


resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = data.aws_ssm_parameter.acm_arn.value

  default_action {
    type = "forward"

    forward {
      target_group {
        arn = aws_lb_target_group.argo.arn
      }
    }
  }

  tags = merge(
    {
      Name = var.project_name
    },
    var.common_tags
  )
}

resource "aws_security_group" "main" {
  name   = var.project_name
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

  tags = {
    Name = var.project_name
  }
}
