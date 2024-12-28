# Review !!!!
# ╷
# │ Error: registering ELBv2 Target Group (arn:aws:elasticloadbalancing:us-east-1:583320401430:targetgroup/linuxtips-multiregion-tg-vpc-link/6387696d34b1819a) target: ValidationError: If the target type is ALB, the target must have at least one listener that matches the target group port or any specified port overrides
# │       status code: 400, request id: d80be4a8-eef6-42a6-8e98-385103857c95
# │ 
# │   with module.cluster.aws_lb_target_group_attachment.internal_lb,
# │   on ../../modules/cluster/vpc_link.tf line 85, in resource "aws_lb_target_group_attachment" "internal_lb":
# │   85: resource "aws_lb_target_group_attachment" "internal_lb" {
# │ 
# ╵

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
