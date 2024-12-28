resource "aws_service_discovery_service" "main" {

  count = var.service_discovery_namespace != null ? 1 : 0

  name = var.ecs_service_name

  dns_config {
    namespace_id = var.service_discovery_namespace

    dns_records {
      ttl  = 10 # TTL in seconds
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1 # After one failute the DNS A registry is removed
  }

  tags = merge(
    {
      Name = var.ecs_service_name
    },
    var.common_tags
  )
}