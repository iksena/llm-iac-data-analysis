output "arn" {
  description = "Amazon Resource Name (ARN) of the rule"
  value       = aws_config_organization_custom_policy_rule.this.arn
}

output "name" {
  description = "Name of the rule"
  value       = aws_config_organization_custom_policy_rule.this.name
}

output "policy_text" {
  description = "Policy definition containing the rule logic"
  value       = aws_config_organization_custom_policy_rule.this.policy_text
}

output "policy_runtime" {
  description = "Runtime system for policy rules"
  value       = aws_config_organization_custom_policy_rule.this.policy_runtime
}

output "trigger_types" {
  description = "List of notification types that trigger AWS Config to run an evaluation for the rule"
  value       = aws_config_organization_custom_policy_rule.this.trigger_types
}

output "region" {
  description = "Region where this resource will be managed"
  value       = aws_config_organization_custom_policy_rule.this.region
}

output "description" {
  description = "Description of the rule"
  value       = aws_config_organization_custom_policy_rule.this.description
}

output "debug_log_delivery_accounts" {
  description = "List of accounts that you can enable debug logging for"
  value       = aws_config_organization_custom_policy_rule.this.debug_log_delivery_accounts
}

output "excluded_accounts" {
  description = "List of AWS account identifiers to exclude from the rule"
  value       = aws_config_organization_custom_policy_rule.this.excluded_accounts
}

output "input_parameters" {
  description = "A string in JSON format that is passed to the AWS Config Rule Lambda Function"
  value       = aws_config_organization_custom_policy_rule.this.input_parameters
}

output "maximum_execution_frequency" {
  description = "Maximum frequency with which AWS Config runs evaluations for a rule"
  value       = aws_config_organization_custom_policy_rule.this.maximum_execution_frequency
}

output "resource_id_scope" {
  description = "Identifier of the AWS resource to evaluate"
  value       = aws_config_organization_custom_policy_rule.this.resource_id_scope
}

output "resource_types_scope" {
  description = "List of types of AWS resources to evaluate"
  value       = aws_config_organization_custom_policy_rule.this.resource_types_scope
}

output "tag_key_scope" {
  description = "Tag key of AWS resources to evaluate"
  value       = aws_config_organization_custom_policy_rule.this.tag_key_scope
}

output "tag_value_scope" {
  description = "Tag value of AWS resources to evaluate"
  value       = aws_config_organization_custom_policy_rule.this.tag_value_scope
}