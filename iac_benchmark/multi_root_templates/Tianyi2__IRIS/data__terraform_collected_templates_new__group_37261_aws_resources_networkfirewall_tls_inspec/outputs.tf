output "arn" {
  description = "ARN of the TLS Inspection Configuration"
  value       = aws_networkfirewall_tls_inspection_configuration.this.arn
}

output "certificate_authority" {
  description = "Certificate Manager certificate block"
  value       = aws_networkfirewall_tls_inspection_configuration.this.certificate_authority
}

output "certificates" {
  description = "List of certificate blocks describing certificates associated with the TLS inspection configuration"
  value       = aws_networkfirewall_tls_inspection_configuration.this.certificates
}

output "number_of_associations" {
  description = "Number of firewall policies that use this TLS inspection configuration"
  value       = aws_networkfirewall_tls_inspection_configuration.this.number_of_associations
}

output "tls_inspection_configuration_id" {
  description = "A unique identifier for the TLS inspection configuration"
  value       = aws_networkfirewall_tls_inspection_configuration.this.tls_inspection_configuration_id
}

output "update_token" {
  description = "String token used when updating the rule group"
  value       = aws_networkfirewall_tls_inspection_configuration.this.update_token
}

output "name" {
  description = "Name of the TLS inspection configuration"
  value       = aws_networkfirewall_tls_inspection_configuration.this.name
}

output "description" {
  description = "Description of the TLS inspection configuration"
  value       = aws_networkfirewall_tls_inspection_configuration.this.description
}

output "region" {
  description = "Region where the resource is managed"
  value       = aws_networkfirewall_tls_inspection_configuration.this.region
}

output "encryption_configuration" {
  description = "Encryption configuration block"
  value       = aws_networkfirewall_tls_inspection_configuration.this.encryption_configuration
}

output "tls_inspection_configuration" {
  description = "TLS inspection configuration block"
  value       = aws_networkfirewall_tls_inspection_configuration.this.tls_inspection_configuration
}

output "tags" {
  description = "Map of tags assigned to the resource"
  value       = aws_networkfirewall_tls_inspection_configuration.this.tags
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider"
  value       = aws_networkfirewall_tls_inspection_configuration.this.tags_all
}