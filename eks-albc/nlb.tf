resource "aws_lb" "ingress" {
  count = var.create_nlb == true ? 1 : 0

  name = format("%s-nlb", var.project_name)

  internal           = false
  load_balancer_type = "network"

  subnets = data.aws_ssm_parameter.public_subnets[*].value

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
  count = var.create_nlb == true ? 1 : 0

  name = format("%s-lb-tg", var.project_name)
  port = 8080
  protocol = "TCP"
  vpc_id = data.aws_ssm_parameter.vpc.value

  tags = merge(
    {
      Name = format("%s-lb-tg", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_lb_listener" "main" {
  count = var.create_nlb == true ? 1 : 0

  load_balancer_arn = aws_lb.ingress[0].arn
  port              = 80
  protocol          = "TCP"
  
  default_action {
      type             = "forward"
      target_group_arn = aws_lb_target_group.main[0].arn
  }
}
