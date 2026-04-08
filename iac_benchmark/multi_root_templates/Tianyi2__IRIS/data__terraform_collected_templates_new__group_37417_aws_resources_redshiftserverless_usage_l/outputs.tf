output "arn" {
  description = "Amazon Resource Name (ARN) of the Redshift Serverless Usage Limit."
  value       = aws_redshiftserverless_usage_limit.this.arn
}

output "id" {
  description = "The Redshift Usage Limit id."
  value       = aws_redshiftserverless_usage_limit.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_redshiftserverless_usage_limit.this.region
}

output "amount" {
  description = "The limit amount."
  value       = aws_redshiftserverless_usage_limit.this.amount
}

output "breach_action" {
  description = "The action that Amazon Redshift Serverless takes when the limit is reached."
  value       = aws_redshiftserverless_usage_limit.this.breach_action
}

output "period" {
  description = "The time period that the amount applies to."
  value       = aws_redshiftserverless_usage_limit.this.period
}

output "resource_arn" {
  description = "The Amazon Resource Name (ARN) of the Amazon Redshift Serverless resource."
  value       = aws_redshiftserverless_usage_limit.this.resource_arn
}

output "usage_type" {
  description = "The type of Amazon Redshift Serverless usage."
  value       = aws_redshiftserverless_usage_limit.this.usage_type
}