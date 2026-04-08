output "arn" {
  description = "The ARN that identifies the provisioning template"
  value       = aws_iot_provisioning_template.this.arn
}

output "default_version_id" {
  description = "The default version of the fleet provisioning template"
  value       = aws_iot_provisioning_template.this.default_version_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_iot_provisioning_template.this.tags_all
}

output "name" {
  description = "The name of the fleet provisioning template"
  value       = aws_iot_provisioning_template.this.name
}

output "description" {
  description = "The description of the fleet provisioning template"
  value       = aws_iot_provisioning_template.this.description
}

output "enabled" {
  description = "True to enable the fleet provisioning template, otherwise false"
  value       = aws_iot_provisioning_template.this.enabled
}

output "provisioning_role_arn" {
  description = "The role ARN for the role associated with the fleet provisioning template"
  value       = aws_iot_provisioning_template.this.provisioning_role_arn
}

output "template_body" {
  description = "The JSON formatted contents of the fleet provisioning template"
  value       = aws_iot_provisioning_template.this.template_body
}

output "type" {
  description = "The type you define in a provisioning template"
  value       = aws_iot_provisioning_template.this.type
}