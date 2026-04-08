output "arn" {
  description = "ARN of the Integration."
  value       = aws_redshift_integration.this.arn
}

output "integration_name" {
  description = "Name of the integration."
  value       = aws_redshift_integration.this.integration_name
}

output "source_arn" {
  description = "ARN of the database to use as the source for replication."
  value       = aws_redshift_integration.this.source_arn
}

output "target_arn" {
  description = "ARN of the Redshift data warehouse to use as the target for replication."
  value       = aws_redshift_integration.this.target_arn
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_redshift_integration.this.region
}

output "additional_encryption_context" {
  description = "Set of non-secret key–value pairs that contains additional contextual information about the data."
  value       = aws_redshift_integration.this.additional_encryption_context
}

output "description" {
  description = "Description of the integration."
  value       = aws_redshift_integration.this.description
}

output "kms_key_id" {
  description = "KMS key identifier for the key to use to encrypt the integration."
  value       = aws_redshift_integration.this.kms_key_id
}

output "tags" {
  description = "Key-value map of resource tags."
  value       = aws_redshift_integration.this.tags
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_redshift_integration.this.tags_all
}