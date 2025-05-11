resource "aws_route53_record" "argocd" {
  zone_id = var.route53.hosted_zone
  name    = "argocd.${replace(var.route53.dns_name, "*.", "")}"
  type    = "CNAME"
  ttl     = "60"
  records = [aws_lb.main.dns_name]
}
