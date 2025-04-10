resource "aws_lb" "ingress" {
  name = format("%s-nlb", var.project_name)

  internal           = false
  load_balancer_type = "network"

  subnets = data.aws_ssm_parameter.public_subnets[*].value

  security_groups = [
    aws_security_group.nlb_sg.id
  ]

  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = false

  tags = merge(
    {
      Name = format("%s-nlb", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_lb_target_group" "main" {
  name     = format("%s-lb-tg", var.project_name)
  port     = 8080
  protocol = "TCP"
  vpc_id   = data.aws_ssm_parameter.vpc.value

  tags = merge(
    {
      Name = format("%s-lb-tg", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_lb_listener" "main" {
  count = var.route53.dns_name == "" || var.route53.hosted_zone == "" ? 1 : 0

  load_balancer_arn = aws_lb.ingress.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  tags = merge(
    {
      Name = format("%s-http-listner", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_lb_listener" "https" {
  count = var.route53.dns_name == "" || var.route53.hosted_zone == "" ? 0 : 1

  certificate_arn = aws_acm_certificate.main[0].arn

  load_balancer_arn = aws_lb.ingress.arn
  port              = "443"
  protocol          = "TLS"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  tags = merge(
    {
      Name = format("%s-https-listner", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_security_group" "nlb_sg" {
  name        = format("%s-nlb-sg", var.project_name)
  description = "Allow NBL traffic"
  vpc_id      = data.aws_ssm_parameter.vpc.value

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    {
      Name = format("%s-nlb-sg", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_security_group_rule" "nlb_allow_all" {
  cidr_blocks       = var.ingress_inbound_cidrs
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  description       = "allow-all"
  type              = "ingress"
  security_group_id = aws_security_group.nlb_sg.id
}
