output "api_mapping_selection_expression" {
  description = "API mapping selection expression for the domain name."
  value       = aws_apigatewayv2_domain_name.this.api_mapping_selection_expression
}

output "arn" {
  description = "ARN of the domain name."
  value       = aws_apigatewayv2_domain_name.this.arn
}

output "id" {
  description = "Domain name identifier."
  value       = aws_apigatewayv2_domain_name.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_apigatewayv2_domain_name.this.tags_all
}

output "domain_name_configuration" {
  description = "Domain name configuration with computed values."
  value = {
    certificate_arn                        = aws_apigatewayv2_domain_name.this.domain_name_configuration[0].certificate_arn
    endpoint_type                          = aws_apigatewayv2_domain_name.this.domain_name_configuration[0].endpoint_type
    hosted_zone_id                         = aws_apigatewayv2_domain_name.this.domain_name_configuration[0].hosted_zone_id
    ip_address_type                        = aws_apigatewayv2_domain_name.this.domain_name_configuration[0].ip_address_type
    ownership_verification_certificate_arn = aws_apigatewayv2_domain_name.this.domain_name_configuration[0].ownership_verification_certificate_arn
    security_policy                        = aws_apigatewayv2_domain_name.this.domain_name_configuration[0].security_policy
    target_domain_name                     = aws_apigatewayv2_domain_name.this.domain_name_configuration[0].target_domain_name
  }
}