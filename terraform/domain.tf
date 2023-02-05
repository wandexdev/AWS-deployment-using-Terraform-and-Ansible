#--------------------------------DATA SOURCE-------------------------------#

data "aws_route53_zone" "existing" {
  name                  = var.existing_domain
}

#--------------------------------REQUEST SSL CERT-------------------------------#

resource "aws_acm_certificate" "subdomain_cert" {
  domain_name           = var.subdomain_name
  validation_method     = "DNS"

  tags = {
    Environment = "${var.environment_prefix}-ACM"
  }
}

#--------------------------------SUB-DOMAIN ALIAS-------------------------------#

resource "aws_route53_record" "alias_record" {
  zone_id      = data.aws_route53_zone.existing.zone_id
  name         = var.subdomain_name
  type         = "A"

  alias {
    name = aws_lb.wandeminiproject.dns_name
    zone_id = aws_lb.wandeminiproject.zone_id
    evaluate_target_health = true
  }
}

#--------------------------------CERTIFICATE VALIDATION-------------------------------#

resource "aws_acm_certificate_validation" "subdomain_cert" {
  certificate_arn         = aws_acm_certificate.subdomain_cert.arn
}

