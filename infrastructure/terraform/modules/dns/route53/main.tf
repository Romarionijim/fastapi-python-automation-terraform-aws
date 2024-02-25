data "aws_route53_zone" "hosted_zone" {
  name         = var.route53_zone_name
  private_zone = false
}

resource "aws_route53_record" "route53_record" {
  zone_id = data.aws_route53_zone.hosted_zone.id
  name    = var.route53_name
  type    = "A"
  alias {
    name                   = var.alb_dns_name
    zone_id                = data.aws_route53_zone.hosted_zone.id
    evaluate_target_health = true
  }
}
