output "api_gateway_domain_targets" {
  value       = { for domain in var.domains : domain.domain =>
    {
      name = (var.api_type == "http"
        ? try(aws_apigatewayv2_domain_name.domain_name[domain.domain].domain_name_configuration[0].target_domain_name, "")
        : try(aws_api_gateway_domain_name.rest_domain_name[domain.domain].hosted_zone_id, ""))
      zone_id = (var.api_type == "http"
        ? try(aws_apigatewayv2_domain_name.domain_name[domain.domain].domain_name_configuration[0].target_domain_name, "")
        : try(aws_api_gateway_domain_name.rest_domain_name[domain.domain].regional_zone_id, ""))
    }
    if var.create_dns_record && (var.api_type == "http" || var.api_type == "rest")
  }
  description = "Targets for creating DNS records manually"
}
