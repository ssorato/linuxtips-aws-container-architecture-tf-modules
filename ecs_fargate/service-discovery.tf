# Service discovery zone
resource "aws_service_discovery_private_dns_namespace" "main" {
  name        = format("%s.discovery.com", var.project_name)
  description = "Service Discovery usede in ECS cluster"
  vpc         = data.aws_ssm_parameter.vpc.value

  tags = merge(
    {
      Name = format("%s.discovery.com", var.project_name)
    },
    var.common_tags
  )
}

# Service discovery zone
resource "aws_service_discovery_private_dns_namespace" "sc" {
  name        = format("%s.local", var.project_name)
  description = "Service Connect usede in ECS cluster"
  vpc         = data.aws_ssm_parameter.vpc.value

  tags = merge(
    {
      Name = format("%s.local", var.project_name)
    },
    var.common_tags
  )
}

