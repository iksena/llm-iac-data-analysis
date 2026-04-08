output "arn" {
  description = "ARN of the Integration."
  value       = aws_rds_integration.this.arn
}

output "id" {
  description = "ARN of the Integration. (Deprecated, use arn instead)"
  value       = aws_rds_integration.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_rds_integration.this.tags_all
}