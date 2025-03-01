resource "aws_efs_file_system" "main" {
  creation_token   = format("%s-efs-shared", var.project_name)
  performance_mode = "generalPurpose"

  tags = merge(
    {
      Name = format("%s-efs-shared", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_security_group" "efs" {
  name   = format("%s-efs-sg", var.project_name)
  vpc_id = data.aws_ssm_parameter.vpc.value

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
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
      Name = format("%s-efs-sg", var.project_name)
    },
    var.common_tags
  )
}

resource "aws_efs_mount_target" "efs_mount_pods" {
  count = length(data.aws_ssm_parameter.pod_subnets)

  file_system_id = aws_efs_file_system.main.id
  subnet_id      = data.aws_ssm_parameter.pod_subnets[count.index].value
  security_groups = [
    aws_security_group.efs.id
  ]
}
