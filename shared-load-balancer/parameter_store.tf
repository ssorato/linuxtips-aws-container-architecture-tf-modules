resource "aws_ssm_parameter" "cluster_01" {
  type  = "String"
  name  = "/${var.project_name}/cluster-01/listener"
  value = aws_lb_target_group.cluster_01.arn

  tags = merge(
    {
      Name = "/${var.project_name}/cluster-01/listener"
    },
    var.common_tags
  )
}


resource "aws_ssm_parameter" "cluster_02" {
  type  = "String"
  name  = "/${var.project_name}/cluster-02/listener"
  value = aws_lb_target_group.cluster_02.arn

  tags = merge(
    {
      Name = "/${var.project_name}/cluster-02/listener"
    },
    var.common_tags
  )
}