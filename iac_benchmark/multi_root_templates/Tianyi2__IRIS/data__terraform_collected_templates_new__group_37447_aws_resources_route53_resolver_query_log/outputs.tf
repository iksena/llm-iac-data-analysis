output "id" {
  description = "The ID of the Route 53 Resolver query logging configuration."
  value       = aws_route53_resolver_query_log_config.this.id
}

output "arn" {
  description = "The ARN (Amazon Resource Name) of the Route 53 Resolver query logging configuration."
  value       = aws_route53_resolver_query_log_config.this.arn
}

output "owner_id" {
  description = "The AWS account ID of the account that created the query logging configuration."
  value       = aws_route53_resolver_query_log_config.this.owner_id
}

output "share_status" {
  description = "An indication of whether the query logging configuration is shared with other AWS accounts, or was shared with the current account by another AWS account. Sharing is configured through AWS Resource Access Manager (AWS RAM). Values are NOT_SHARED, SHARED_BY_ME or SHARED_WITH_ME."
  value       = aws_route53_resolver_query_log_config.this.share_status
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_route53_resolver_query_log_config.this.tags_all
}