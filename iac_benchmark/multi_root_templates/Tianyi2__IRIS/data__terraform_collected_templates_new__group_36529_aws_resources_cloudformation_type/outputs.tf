output "arn" {
  description = "Amazon Resource Name (ARN) of the CloudFormation Type version."
  value       = aws_cloudformation_type.this.arn
}

output "default_version_id" {
  description = "Identifier of the CloudFormation Type default version."
  value       = aws_cloudformation_type.this.default_version_id
}

output "deprecated_status" {
  description = "Deprecation status of the version."
  value       = aws_cloudformation_type.this.deprecated_status
}

output "description" {
  description = "Description of the version."
  value       = aws_cloudformation_type.this.description
}

output "documentation_url" {
  description = "URL of the documentation for the CloudFormation Type."
  value       = aws_cloudformation_type.this.documentation_url
}

output "is_default_version" {
  description = "Whether the CloudFormation Type version is the default version."
  value       = aws_cloudformation_type.this.is_default_version
}

output "provisioning_type" {
  description = "Provisioning behavior of the CloudFormation Type."
  value       = aws_cloudformation_type.this.provisioning_type
}

output "schema" {
  description = "JSON document of the CloudFormation Type schema."
  value       = aws_cloudformation_type.this.schema
}

output "source_url" {
  description = "URL of the source code for the CloudFormation Type."
  value       = aws_cloudformation_type.this.source_url
}

output "type_arn" {
  description = "Amazon Resource Name (ARN) of the CloudFormation Type."
  value       = aws_cloudformation_type.this.type_arn
}

output "version_id" {
  description = "Identifier of the CloudFormation Type version."
  value       = aws_cloudformation_type.this.version_id
}

output "visibility" {
  description = "Scope of the CloudFormation Type."
  value       = aws_cloudformation_type.this.visibility
}