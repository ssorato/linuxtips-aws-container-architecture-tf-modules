resource "aws_route53_record" "grafana" {
  zone_id = var.route53.hosted_zone
  name    = "${var.grafana_host}.${replace(var.route53.dns_name, "*.", "")}"
  type    = "CNAME"
  ttl     = "60"
  records = [aws_lb.ingress.dns_name]

  depends_on = [
    helm_release.istio_ingress
  ]
}

resource "aws_route53_record" "health_api" {
  zone_id = var.route53.hosted_zone
  name    = "health.${replace(var.route53.dns_name, "*.", "")}"
  type    = "CNAME"
  ttl     = "60"
  records = [aws_lb.ingress.dns_name]

  depends_on = [
    helm_release.istio_ingress
  ]
}

resource "aws_route53_record" "chip" {
  zone_id = var.route53.hosted_zone
  name    = "chip.${replace(var.route53.dns_name, "*.", "")}"
  type    = "CNAME"
  ttl     = "60"
  records = [aws_lb.ingress.dns_name]

  depends_on = [
    helm_release.istio_ingress
  ]
}

resource "aws_route53_record" "jaeger" {
  zone_id = var.route53.hosted_zone
  name    = "${var.jaeger_host}.${replace(var.route53.dns_name, "*.", "")}"
  type    = "CNAME"
  ttl     = "60"
  records = [aws_lb.ingress.dns_name]

  depends_on = [
    helm_release.istio_ingress
  ]
}

resource "aws_route53_record" "kiali" {
  zone_id = var.route53.hosted_zone
  name    = "${var.kiali_host}.${replace(var.route53.dns_name, "*.", "")}"
  type    = "CNAME"
  ttl     = "60"
  records = [aws_lb.ingress.dns_name]

  depends_on = [
    helm_release.istio_ingress
  ]
}


