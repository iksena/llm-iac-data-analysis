output "data_protection_settings_arn" {
  description = "ARN of the data protection settings resource."
  value       = aws_workspacesweb_data_protection_settings.this.data_protection_settings_arn
}

output "associated_portal_arns" {
  description = "List of web portal ARNs that this data protection settings resource is associated with."
  value       = aws_workspacesweb_data_protection_settings.this.associated_portal_arns
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_workspacesweb_data_protection_settings.this.tags_all
}

output "display_name" {
  description = "The display name of the data protection settings."
  value       = aws_workspacesweb_data_protection_settings.this.display_name
}

output "additional_encryption_context" {
  description = "Additional encryption context for the data protection settings."
  value       = aws_workspacesweb_data_protection_settings.this.additional_encryption_context
}

output "customer_managed_key" {
  description = "ARN of the customer managed KMS key."
  value       = aws_workspacesweb_data_protection_settings.this.customer_managed_key
}

output "description" {
  description = "The description of the data protection settings."
  value       = aws_workspacesweb_data_protection_settings.this.description
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_workspacesweb_data_protection_settings.this.region
}

output "tags" {
  description = "Map of tags assigned to the resource."
  value       = aws_workspacesweb_data_protection_settings.this.tags
}

output "inline_redaction_configuration" {
  description = "The inline redaction configuration of the data protection settings."
  value       = aws_workspacesweb_data_protection_settings.this.inline_redaction_configuration
}