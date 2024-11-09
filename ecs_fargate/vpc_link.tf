resource "aws_security_group" "vpclink" {
  name   = format("%s-vpclink-sg", var.project_name)
  vpc_id = data.aws_ssm_parameter.vpc.value

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = merge(
    {
      Name = format("%s-vpclink-sg", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_security_group_rule" "vpclink_ingress_80" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  to_port           = 80
  description       = "Enable ingress HTTP traffic"
  protocol          = "tcp"
  security_group_id = aws_security_group.vpclink.id
  type              = "ingress"
}

resource "aws_lb" "vpclink" {
  name     = format("%s-nlb-vpc-link", var.project_name)
  internal = true

  load_balancer_type = "network"

  subnets = data.aws_ssm_parameter.private_subnet[*].value

  security_groups = [
    aws_security_group.vpclink.id
  ]

  enable_cross_zone_load_balancing = false
  enable_deletion_protection       = false

  tags = merge(
    {
      Name = format("%s-nlb-vpc-link", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_lb_target_group" "vpclink" {
  name        = format("%s-nlb-vpc-link-tg", var.project_name)
  port        = 80
  protocol    = "TCP"
  target_type = "alb" # NBL -> ALB

  vpc_id = data.aws_ssm_parameter.vpc.value

  target_health_state {
    enable_unhealthy_connection_termination = false # due to ALB as target ( ALB has dynamic IPs )
  }

  tags = merge(
    {
      Name = format("%s-nlb-vpc-link-tg", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_lb_listener" "vpclink" {
  load_balancer_arn = aws_lb.vpclink.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vpclink.arn
  }

  tags       = var.common_tags
  depends_on = [aws_lb_target_group.vpclink] # ValidationError: If the target type is ALB, the target must have at least one listener that matches the target group port or any specified port overrides
}

resource "aws_lb_target_group_attachment" "internal_lb" {
  target_group_arn = aws_lb_target_group.vpclink.arn
  target_id        = aws_lb.ecs_alb_internal.id
  port             = 80
}

resource "aws_api_gateway_vpc_link" "main" {
  name = format("%s-api-gw-vpc-link", var.project_name)

  target_arns = [
    aws_lb.vpclink.arn
  ]

  tags = merge(
    {
      Name = format("%s-api-gw-vpc-link", var.project_name)
    },
    var.common_tags
  )
}
