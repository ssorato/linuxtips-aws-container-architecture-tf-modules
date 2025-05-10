resource "aws_security_group" "main" {
  name   = format("shared-alb-%s", var.project_name)
  vpc_id = data.aws_ssm_parameter.vpc.value


  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.alb_public_access_cidrs
  }


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
      Name = format("shared-alb-%s", var.project_name)
    },
    var.common_tags
  )

}