resource "aws_acm_certificate" "main" {
  count             = var.route53.dns_name == "" || var.route53.hosted_zone == "" ? 0 : 1
  domain_name       = var.route53.dns_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      Name = replace(var.route53.dns_name, "*.", "") # Avoid error on wild-card dns name
    },
    var.common_tags
  )
}

resource "aws_route53_record" "main" {
  for_each = var.route53.dns_name == "" || var.route53.hosted_zone == "" ? {} : {
    for dvo in aws_acm_certificate.main[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.route53.hosted_zone
}

resource "aws_acm_certificate_validation" "main" {
  count = var.route53.dns_name == "" || var.route53.hosted_zone == "" ? 0 : 1

  certificate_arn         = aws_acm_certificate.main[0].arn
  validation_record_fqdns = [for record in aws_route53_record.main : record.fqdn]
}
