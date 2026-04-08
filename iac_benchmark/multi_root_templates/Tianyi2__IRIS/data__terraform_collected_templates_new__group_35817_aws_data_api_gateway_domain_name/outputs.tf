output "arn" {
  description = "ARN of the found custom domain name."
  value       = data.aws_api_gateway_domain_name.this.arn
}

output "certificate_arn" {
  description = "ARN for an AWS-managed certificate that is used by edge-optimized endpoint for this domain name."
  value       = data.aws_api_gateway_domain_name.this.certificate_arn
}

output "certificate_name" {
  description = "Name of the certificate that is used by edge-optimized endpoint for this domain name."
  value       = data.aws_api_gateway_domain_name.this.certificate_name
}

output "certificate_upload_date" {
  description = "Upload date associated with the domain certificate."
  value       = data.aws_api_gateway_domain_name.this.certificate_upload_date
}

output "cloudfront_domain_name" {
  description = "Hostname created by Cloudfront to represent the distribution that implements this domain name mapping."
  value       = data.aws_api_gateway_domain_name.this.cloudfront_domain_name
}

output "cloudfront_zone_id" {
  description = "For convenience, the hosted zone ID (Z2FDTNDATAQYW2) that can be used to create a Route53 alias record for the distribution."
  value       = data.aws_api_gateway_domain_name.this.cloudfront_zone_id
}

output "endpoint_configuration" {
  description = "List of objects with the endpoint configuration of this domain name."
  value       = data.aws_api_gateway_domain_name.this.endpoint_configuration
}

output "policy" {
  description = "A stringified JSON policy document that applies to the execute-api service for this DomainName regardless of the caller and Method configuration. Supported only for private custom domain names."
  value       = data.aws_api_gateway_domain_name.this.policy
}

output "regional_certificate_arn" {
  description = "ARN for an AWS-managed certificate that is used for validating the regional domain name."
  value       = data.aws_api_gateway_domain_name.this.regional_certificate_arn
}

output "regional_certificate_name" {
  description = "User-friendly name of the certificate that is used by regional endpoint for this domain name."
  value       = data.aws_api_gateway_domain_name.this.regional_certificate_name
}

output "regional_domain_name" {
  description = "Hostname for the custom domain's regional endpoint."
  value       = data.aws_api_gateway_domain_name.this.regional_domain_name
}

output "regional_zone_id" {
  description = "Hosted zone ID that can be used to create a Route53 alias record for the regional endpoint."
  value       = data.aws_api_gateway_domain_name.this.regional_zone_id
}

output "security_policy" {
  description = "Security policy for the domain name."
  value       = data.aws_api_gateway_domain_name.this.security_policy
}

output "tags" {
  description = "Key-value map of tags for the resource."
  value       = data.aws_api_gateway_domain_name.this.tags
}

output "domain_name" {
  description = "Fully-qualified domain name to look up."
  value       = data.aws_api_gateway_domain_name.this.domain_name
}

output "domain_name_id" {
  description = "The identifier for the domain name resource."
  value       = data.aws_api_gateway_domain_name.this.domain_name_id
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_api_gateway_domain_name.this.region
}