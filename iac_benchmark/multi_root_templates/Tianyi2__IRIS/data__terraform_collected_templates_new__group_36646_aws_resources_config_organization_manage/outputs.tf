output "arn" {
  description = "Amazon Resource Name (ARN) of the rule"
  value       = aws_config_organization_managed_rule.this.arn
}

output "name" {
  description = "The name of the rule"
  value       = aws_config_organization_managed_rule.this.name
}

output "rule_identifier" {
  description = "Identifier of the AWS Config Managed Rule"
  value       = aws_config_organization_managed_rule.this.rule_identifier
}

output "description" {
  description = "Description of the rule"
  value       = aws_config_organization_managed_rule.this.description
}

output "excluded_accounts" {
  description = "List of AWS account identifiers excluded from the rule"
  value       = aws_config_organization_managed_rule.this.excluded_accounts
}

output "input_parameters" {
  description = "JSON string passed to the AWS Config Rule Lambda Function"
  value       = aws_config_organization_managed_rule.this.input_parameters
}

output "maximum_execution_frequency" {
  description = "Maximum frequency with which AWS Config runs evaluations for the rule"
  value       = aws_config_organization_managed_rule.this.maximum_execution_frequency
}

output "region" {
  description = "Region where the resource is managed"
  value       = aws_config_organization_managed_rule.this.region
}

output "resource_id_scope" {
  description = "Identifier of the AWS resource to evaluate"
  value       = aws_config_organization_managed_rule.this.resource_id_scope
}

output "resource_types_scope" {
  description = "List of types of AWS resources to evaluate"
  value       = aws_config_organization_managed_rule.this.resource_types_scope
}

output "tag_key_scope" {
  description = "Tag key of AWS resources to evaluate"
  value       = aws_config_organization_managed_rule.this.tag_key_scope
}

output "tag_value_scope" {
  description = "Tag value of AWS resources to evaluate"
  value       = aws_config_organization_managed_rule.this.tag_value_scope
}