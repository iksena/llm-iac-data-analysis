output "arn" {
  description = "ARN of the Contributor Managed Insight Rule"
  value       = aws_cloudwatch_contributor_managed_insight_rule.this.arn
}

output "resource_arn" {
  description = "ARN of an Amazon Web Services resource that has managed Contributor Insights rules"
  value       = aws_cloudwatch_contributor_managed_insight_rule.this.resource_arn
}

output "template_name" {
  description = "Template name for the managed Contributor Insights rule"
  value       = aws_cloudwatch_contributor_managed_insight_rule.this.template_name
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_cloudwatch_contributor_managed_insight_rule.this.region
}

