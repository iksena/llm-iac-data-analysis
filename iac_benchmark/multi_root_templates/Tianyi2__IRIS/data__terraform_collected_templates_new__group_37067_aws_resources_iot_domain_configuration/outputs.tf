output "arn" {
  description = "The ARN of the domain configuration."
  value       = aws_iot_domain_configuration.this.arn
}

output "domain_type" {
  description = "The type of the domain."
  value       = aws_iot_domain_configuration.this.domain_type
}

output "id" {
  description = "The name of the created domain configuration."
  value       = aws_iot_domain_configuration.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_iot_domain_configuration.this.tags_all
}