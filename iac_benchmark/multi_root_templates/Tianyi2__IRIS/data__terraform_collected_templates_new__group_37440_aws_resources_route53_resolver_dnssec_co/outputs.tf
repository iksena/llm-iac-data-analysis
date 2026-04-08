output "arn" {
  description = "The ARN for a configuration for DNSSEC validation."
  value       = aws_route53_resolver_dnssec_config.this.arn
}

output "id" {
  description = "The ID for a configuration for DNSSEC validation."
  value       = aws_route53_resolver_dnssec_config.this.id
}

output "owner_id" {
  description = "The owner account ID of the virtual private cloud (VPC) for a configuration for DNSSEC validation."
  value       = aws_route53_resolver_dnssec_config.this.owner_id
}

output "validation_status" {
  description = "The validation status for a DNSSEC configuration. The status can be one of the following: ENABLING, ENABLED, DISABLING and DISABLED."
  value       = aws_route53_resolver_dnssec_config.this.validation_status
}