output "managed_rules" {
  description = "Managed rules that are available for the specified Amazon Web Services resource."
  value       = data.aws_cloudwatch_contributor_managed_insight_rules.this.managed_rules
}

output "template_name" {
  description = "Template name for the managed rule. Used to enable managed rules using PutManagedInsightRules."
  value       = try(data.aws_cloudwatch_contributor_managed_insight_rules.this.managed_rules[*].template_name, [])
}

output "resource_arn" {
  description = "If a managed rule is enabled, this is the ARN for the related Amazon Web Services resource."
  value       = try(data.aws_cloudwatch_contributor_managed_insight_rules.this.managed_rules[*].resource_arn, [])
}

output "rule_state" {
  description = "Describes the state of a managed rule. If the rule is enabled, it contains information about the Contributor Insights rule that contains information about the related Amazon Web Services resource."
  value       = try(data.aws_cloudwatch_contributor_managed_insight_rules.this.managed_rules[*].rule_state, [])
}

output "rule_name" {
  description = "Name of the Contributor Insights rule that contains data for the specified Amazon Web Services resource."
  value       = try(data.aws_cloudwatch_contributor_managed_insight_rules.this.managed_rules[*].rule_state[*].rule_name, [])
}

output "state" {
  description = "Indicates whether the rule is enabled or disabled."
  value       = try(data.aws_cloudwatch_contributor_managed_insight_rules.this.managed_rules[*].rule_state[*].state, [])
}