resource "aws_route53_zone" "private" {
  name = format("%s.local", var.project_name)

  vpc {
    vpc_id = data.aws_ssm_parameter.vpc.value
  }

  tags = merge(
    {
      Name = var.project_name
    },
    var.common_tags
  )
}

resource "aws_route53_record" "loki" {
  zone_id = aws_route53_zone.private.zone_id
  name    = format("loki.%s.local", var.project_name)
  type    = "CNAME"
  ttl     = "30"
  records = [aws_lb.loki.dns_name]
}

resource "aws_route53_record" "tempo" {
  zone_id = aws_route53_zone.private.zone_id
  name    = format("tempo.%s.local", var.project_name)
  type    = "CNAME"
  ttl     = "30"
  records = [aws_lb.tempo.dns_name]
}

resource "aws_route53_record" "grafana" {
  count   = var.route53.dns_name == "" || var.route53.hosted_zone == "" ? 0 : 1
  zone_id = var.route53.hosted_zone
  name    = "grafana.${replace(var.route53.dns_name, "*.", "")}"
  type    = "CNAME"
  ttl     = "60"
  records = [aws_lb.grafana.dns_name]
}


resource "aws_route53_record" "mimir" {
  zone_id = aws_route53_zone.private.zone_id
  name    = format("mimir.%s.local", var.project_name)
  type    = "CNAME"
  ttl     = "30"
  records = [aws_lb.mimir.dns_name]
}
