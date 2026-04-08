output "arn" {
  description = "Amazon Resource Name (ARN) of the rule"
  value       = aws_config_organization_custom_rule.this.arn
}

output "lambda_function_arn" {
  description = "Amazon Resource Name (ARN) of the rule Lambda Function"
  value       = aws_config_organization_custom_rule.this.lambda_function_arn
}

output "name" {
  description = "The name of the rule"
  value       = aws_config_organization_custom_rule.this.name
}

output "trigger_types" {
  description = "List of notification types that trigger AWS Config to run an evaluation for the rule"
  value       = aws_config_organization_custom_rule.this.trigger_types
}

output "description" {
  description = "Description of the rule"
  value       = aws_config_organization_custom_rule.this.description
}

output "excluded_accounts" {
  description = "List of AWS account identifiers to exclude from the rule"
  value       = aws_config_organization_custom_rule.this.excluded_accounts
}

output "input_parameters" {
  description = "A string in JSON format that is passed to the AWS Config Rule Lambda Function"
  value       = aws_config_organization_custom_rule.this.input_parameters
}

output "maximum_execution_frequency" {
  description = "The maximum frequency with which AWS Config runs evaluations for a rule"
  value       = aws_config_organization_custom_rule.this.maximum_execution_frequency
}

output "resource_id_scope" {
  description = "Identifier of the AWS resource to evaluate"
  value       = aws_config_organization_custom_rule.this.resource_id_scope
}

output "resource_types_scope" {
  description = "List of types of AWS resources to evaluate"
  value       = aws_config_organization_custom_rule.this.resource_types_scope
}

output "tag_key_scope" {
  description = "Tag key of AWS resources to evaluate"
  value       = aws_config_organization_custom_rule.this.tag_key_scope
}

output "tag_value_scope" {
  description = "Tag value of AWS resources to evaluate"
  value       = aws_config_organization_custom_rule.this.tag_value_scope
}