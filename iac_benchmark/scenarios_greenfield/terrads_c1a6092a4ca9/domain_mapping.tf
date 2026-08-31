
resource "aws_apigatewayv2_domain_name" "domain_name" {
  for_each    = { for domain in var.domains : domain.domain => domain if var.api_type == "http" }
  domain_name = each.value.domain

  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.certificates[each.value.domain].arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "domain_mapping" {
  for_each        = { for domain in var.domains : domain.domain => domain if var.api_type == "http" }
  api_id          = aws_apigatewayv2_api.api[0].id
  domain_name     = aws_apigatewayv2_domain_name.domain_name[each.value.domain].id
  stage           = aws_apigatewayv2_stage.stage[0].id
  api_mapping_key = each.value.api_route_mapping
}

resource "aws_route53_record" "hosted_zone" {
  for_each = { for domain in var.domains : domain.domain => domain if var.api_type == "http" && var.create_dns_record }
  name     = aws_apigatewayv2_domain_name.domain_name[each.value.domain].domain_name
  type     = "A"
  zone_id  = data.aws_route53_zone.hosted_zones[each.value.domain].id

  alias {
    name                   = aws_apigatewayv2_domain_name.domain_name[each.value.domain].domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.domain_name[each.value.domain].domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_api_gateway_domain_name" "rest_domain_name" {
  for_each                 = { for domain in var.domains : domain.domain => domain if var.api_type == "rest" }
  domain_name              = each.value.domain
  regional_certificate_arn = data.aws_acm_certificate.certificates[each.value.domain].arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "rest_api_mapping" {
  for_each    = { for domain in var.domains : domain.domain => domain if var.api_type == "rest" }
  api_id      = aws_api_gateway_rest_api.rest_api[0].id
  domain_name = aws_api_gateway_domain_name.rest_domain_name[each.value.domain].domain_name
  stage_name  = "${var.environment_name}-stage"
  depends_on  = [aws_api_gateway_stage.rest_stage]
}

resource "aws_route53_record" "rest_api_records" {
  for_each = { for domain in var.domains : domain.domain => domain if var.api_type == "rest" && var.create_dns_record }
  name     = aws_api_gateway_domain_name.rest_domain_name[each.value.domain].domain_name
  type     = "A"
  zone_id  = data.aws_route53_zone.hosted_zones[each.value.domain].id

  alias {
    evaluate_target_health = false
    name                   = aws_api_gateway_domain_name.rest_domain_name[each.value.domain].regional_domain_name
    zone_id                = aws_api_gateway_domain_name.rest_domain_name[each.value.domain].regional_zone_id
  }
}
