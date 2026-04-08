output "name" {
  description = "Name of the parameter."
  value       = aws_ssm_parameter.this.name
}

output "type" {
  description = "Type of the parameter."
  value       = aws_ssm_parameter.this.type
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_ssm_parameter.this.region
}

output "allowed_pattern" {
  description = "Regular expression used to validate the parameter value."
  value       = aws_ssm_parameter.this.allowed_pattern
}

output "data_type" {
  description = "Data type of the parameter."
  value       = aws_ssm_parameter.this.data_type
}

output "description" {
  description = "Description of the parameter."
  value       = aws_ssm_parameter.this.description
}

output "insecure_value" {
  description = "Value of the parameter (insecure)."
  value       = aws_ssm_parameter.this.insecure_value
}

output "key_id" {
  description = "KMS key ID or ARN for encrypting a SecureString."
  value       = aws_ssm_parameter.this.key_id
}

output "overwrite" {
  description = "Whether to overwrite an existing parameter."
  value       = aws_ssm_parameter.this.overwrite
}

output "tags" {
  description = "Map of tags assigned to the object."
  value       = aws_ssm_parameter.this.tags
}

output "tier" {
  description = "Parameter tier assigned to the parameter."
  value       = aws_ssm_parameter.this.tier
}

output "value" {
  description = "Value of the parameter."
  value       = aws_ssm_parameter.this.value
  sensitive   = true
}

output "value_wo" {
  description = "Value of the parameter (write-only)."
  value       = aws_ssm_parameter.this.value_wo
  sensitive   = true
}

output "value_wo_version" {
  description = "Version used to trigger updates for value_wo."
  value       = aws_ssm_parameter.this.value_wo_version
}

output "arn" {
  description = "ARN of the parameter."
  value       = aws_ssm_parameter.this.arn
}

output "has_value_wo" {
  description = "Indicates whether the resource has a value_wo set."
  value       = aws_ssm_parameter.this.has_value_wo
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ssm_parameter.this.tags_all
}

output "version" {
  description = "Version of the parameter."
  value       = aws_ssm_parameter.this.version
}