resource "aws_security_group" "main" {
  name = format("%s-vpc-sg", var.project_name)

  vpc_id = var.vpc_id

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
      Name = format("%s-vpc-sg", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_security_group_rule" "subnet_ranges" {
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  type              = "ingress"
  description       = "Enable ingress traffic to the VPC"
  security_group_id = aws_security_group.main.id
  cidr_blocks       = ["10.0.0.0/16"]
}