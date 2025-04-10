resource "aws_security_group_rule" "nodeports" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 30000
  to_port           = 32768
  protocol          = "tcp"
  description       = "Nodeports"
  type              = "ingress"
  security_group_id = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

resource "aws_security_group_rule" "coredns_udp" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  description       = "CoreDNS"
  type              = "ingress"
  security_group_id = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}


resource "aws_security_group_rule" "coredns_tcp" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 53
  to_port           = 53
  protocol          = "tcp"
  description       = "CoreDNS"
  type              = "ingress"
  security_group_id = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

#
# used by metric server option "--kubelet-preferred-address-types=InternalIP"
#
resource "aws_security_group_rule" "kubelet_tcp" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 10250
  to_port           = 10250
  protocol          = "tcp"
  description       = "Kubelet"
  type              = "ingress"
  security_group_id = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

#
# used by metric server option "--kubelet-preferred-address-types=InternalIP"
#
resource "aws_security_group_rule" "metric_server_tcp" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 8443
  to_port           = 8443
  protocol          = "tcp"
  description       = "metric-server"
  type              = "ingress"
  security_group_id = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

#
# EFS access
resource "aws_security_group" "efs" {
  name   = format("%s-efs", var.project_name)
  vpc_id = data.aws_ssm_parameter.vpc.value

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = merge(
    {
      Name = format("%s-efs", var.project_name)
    },
    var.common_tags
  )
}
