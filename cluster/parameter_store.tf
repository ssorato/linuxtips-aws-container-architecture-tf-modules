resource "aws_ssm_parameter" "vpc_link" {
  name  = format("/%s/ecs/vpc-link/id", var.project_name)
  value = aws_api_gateway_vpc_link.main.id
  type  = "String"

  tags = merge(
    {
      Name = format("/%s/ecs/vpc-link/id", var.project_name)
    },
    var.common_tags
  )
}
