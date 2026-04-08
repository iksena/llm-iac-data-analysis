output "id" {
  description = "The ID for the query logging configuration."
  value       = data.aws_route53_resolver_query_log_config.this.id
}

output "arn" {
  description = "Computed ARN of the Route53 Resolver Query Logging Configuration."
  value       = data.aws_route53_resolver_query_log_config.this.arn
}

output "destination_arn" {
  description = "The ARN of the resource that you want Resolver to send query logs: an Amazon S3 bucket, a CloudWatch Logs log group or a Kinesis Data Firehose delivery stream."
  value       = data.aws_route53_resolver_query_log_config.this.destination_arn
}

output "name" {
  description = "The name of the query logging configuration."
  value       = data.aws_route53_resolver_query_log_config.this.name
}

output "owner_id" {
  description = "The AWS account ID for the account that created the query logging configuration."
  value       = data.aws_route53_resolver_query_log_config.this.owner_id
}

output "share_status" {
  description = "An indication of whether the query logging configuration is shared with other AWS accounts or was shared with the current account by another AWS account."
  value       = data.aws_route53_resolver_query_log_config.this.share_status
}

output "tags" {
  description = "Map of tags to assign to the service."
  value       = data.aws_route53_resolver_query_log_config.this.tags
}