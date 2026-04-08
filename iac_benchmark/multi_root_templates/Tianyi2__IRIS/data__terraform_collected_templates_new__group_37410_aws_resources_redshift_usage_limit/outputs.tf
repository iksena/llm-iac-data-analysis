output "arn" {
  description = "Amazon Resource Name (ARN) of the Redshift Usage Limit."
  value       = aws_redshift_usage_limit.this.arn
}

output "id" {
  description = "The Redshift Usage Limit ID."
  value       = aws_redshift_usage_limit.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_redshift_usage_limit.this.tags_all
}