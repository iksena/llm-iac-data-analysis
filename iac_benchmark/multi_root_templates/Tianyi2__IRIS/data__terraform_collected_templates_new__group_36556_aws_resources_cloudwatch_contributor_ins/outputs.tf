output "resource_arn" {
  description = "ARN of the Contributor Insight Rule."
  value       = aws_cloudwatch_contributor_insight_rule.this.resource_arn
}

output "rule_definition" {
  description = "Definition of the rule, as a JSON object."
  value       = aws_cloudwatch_contributor_insight_rule.this.rule_definition
}

output "rule_name" {
  description = "Unique name of the rule."
  value       = aws_cloudwatch_contributor_insight_rule.this.rule_name
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_cloudwatch_contributor_insight_rule.this.region
}

output "rule_state" {
  description = "State of the rule."
  value       = aws_cloudwatch_contributor_insight_rule.this.rule_state
}