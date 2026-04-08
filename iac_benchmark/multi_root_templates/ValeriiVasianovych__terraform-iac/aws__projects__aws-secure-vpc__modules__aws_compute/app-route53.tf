# http
# resource "aws_route53_record" "app_domain_record" {
#   zone_id = var.hosted_zone_id
#   name    = var.hosted_zone_name
#   type    = "A"
  
#   alias {
#     name                   = aws_lb.private_instance_alb[0].dns_name
#     zone_id                = aws_lb.private_instance_alb[0].zone_id
#     evaluate_target_health = true                                    
#   }
  
#   depends_on = [aws_lb.private_instance_alb]
# }

# https
resource "aws_acm_certificate" "app_domain_cert" {
  count             = local.create_private_resources ? 1 : 0
  domain_name       = "app.${var.hosted_zone_name}"
  validation_method = "DNS"
  
  # subject_alternative_names = ["app.${var.hosted_zone_name}"]  # Modified to include wildcard if needed
  
  tags = {
    Name = "${var.env}-app-certificate"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "app_cert_validation" {
  for_each = local.create_private_resources ? {
    for dvo in aws_acm_certificate.app_domain_cert[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.hosted_zone_id
}

resource "aws_acm_certificate_validation" "app_cert" {
  count                   = local.create_private_resources ? 1 : 0
  certificate_arn         = aws_acm_certificate.app_domain_cert[0].arn
  validation_record_fqdns = [for record in aws_route53_record.app_cert_validation : record.fqdn]
}

resource "aws_route53_record" "app_domain_record" {
  count   = local.create_private_resources ? 1 : 0
  zone_id = var.hosted_zone_id
  name    = "app.${var.hosted_zone_name}"
  type    = "A"

  alias {
    name                   = local.use_nlb ? aws_lb.private_instance_nlb[0].dns_name : (local.use_alb ? aws_lb.private_instance_alb[0].dns_name : "")
    zone_id                = local.use_nlb ? aws_lb.private_instance_nlb[0].zone_id : (local.use_alb ? aws_lb.private_instance_alb[0].zone_id : "")
    evaluate_target_health = true
  }

  depends_on = [aws_lb.private_instance_nlb, aws_lb.private_instance_alb]
}