output "account_id" {
  description = "Account ID"
  value       = aws_config_aggregate_authorization.this.account_id
}

output "authorized_aws_region" {
  description = "The region authorized to collect aggregated data"
  value       = aws_config_aggregate_authorization.this.authorized_aws_region
}

output "tags" {
  description = "A map of tags assigned to the resource"
  value       = aws_config_aggregate_authorization.this.tags
}

output "arn" {
  description = "The ARN of the authorization"
  value       = aws_config_aggregate_authorization.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_config_aggregate_authorization.this.tags_all
}