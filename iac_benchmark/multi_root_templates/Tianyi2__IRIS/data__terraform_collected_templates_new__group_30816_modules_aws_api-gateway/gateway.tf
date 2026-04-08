resource "aws_apigatewayv2_api" "api-gw" {
  name          = var.name
  protocol_type = "HTTP"
  description = var.description
  disable_execute_api_endpoint =  var.domain != "" ? true : false
  dynamic cors_configuration {
    for_each = var.cors_configuration
    content {
      allow_origins = each.value.allow_origins
      allow_methods = each.value.allow_methods
      allow_headers = each.value.allow_headers
    }
  }
}

resource "aws_apigatewayv2_stage" "api-gw" {
  count = var.stage != "" ? 1 : 0
  api_id = aws_apigatewayv2_api.api-gw.id
  name        = var.stage
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}


# certificate
data "aws_acm_certificate" "certificate" {
  count    = var.domain != "" ? 1 : 0
  domain   = var.domain
  statuses = ["ISSUED", "PENDING_VALIDATION"]
}

# route53 zone
data "aws_route53_zone" "zone" {
  count    = var.domain != "" ? 1 : 0

  name         = var.domain
  private_zone = false
}

resource "aws_apigatewayv2_domain_name" "domain" {
  count    = var.domain != "" ? 1 : 0

  domain_name = var.subdomain != "" ? var.subdomain : var.domain

  domain_name_configuration {
    certificate_arn = data.aws_acm_certificate.certificate[0].arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_route53_record" "domain" {
  count    = var.domain != "" ? 1 : 0
  name    = aws_apigatewayv2_domain_name.domain[0].domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.zone[0].zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.domain[0].domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.domain[0].domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}