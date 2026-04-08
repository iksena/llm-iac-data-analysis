output "policy_template_id" {
  description = "The ID of the Policy Template."
  value       = aws_verifiedpermissions_policy_template.this.policy_template_id
}

output "created_date" {
  description = "The date the Policy Template was created."
  value       = aws_verifiedpermissions_policy_template.this.created_date
}

output "policy_store_id" {
  description = "The ID of the Policy Store."
  value       = aws_verifiedpermissions_policy_template.this.policy_store_id
}

output "statement" {
  description = "The content of the statement, written in Cedar policy language."
  value       = aws_verifiedpermissions_policy_template.this.statement
}

output "description" {
  description = "The description for the policy template."
  value       = aws_verifiedpermissions_policy_template.this.description
}

output "region" {
  description = "The region where this resource is managed."
  value       = aws_verifiedpermissions_policy_template.this.region
}