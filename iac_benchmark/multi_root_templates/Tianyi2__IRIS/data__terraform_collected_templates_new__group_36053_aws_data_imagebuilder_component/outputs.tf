output "arn" {
  description = "ARN of the component"
  value       = data.aws_imagebuilder_component.this.arn
}

output "change_description" {
  description = "Change description of the component"
  value       = data.aws_imagebuilder_component.this.change_description
}

output "data" {
  description = "Data of the component"
  value       = data.aws_imagebuilder_component.this.data
}

output "date_created" {
  description = "Date the component was created"
  value       = data.aws_imagebuilder_component.this.date_created
}

output "description" {
  description = "Description of the component"
  value       = data.aws_imagebuilder_component.this.description
}

output "encrypted" {
  description = "Encryption status of the component"
  value       = data.aws_imagebuilder_component.this.encrypted
}

output "kms_key_id" {
  description = "ARN of the Key Management Service (KMS) Key used to encrypt the component"
  value       = data.aws_imagebuilder_component.this.kms_key_id
}

output "name" {
  description = "Name of the component"
  value       = data.aws_imagebuilder_component.this.name
}

output "owner" {
  description = "Owner of the component"
  value       = data.aws_imagebuilder_component.this.owner
}

output "platform" {
  description = "Platform of the component"
  value       = data.aws_imagebuilder_component.this.platform
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_imagebuilder_component.this.region
}

output "supported_os_versions" {
  description = "Operating Systems (OSes) supported by the component"
  value       = data.aws_imagebuilder_component.this.supported_os_versions
}

output "tags" {
  description = "Key-value map of resource tags for the component"
  value       = data.aws_imagebuilder_component.this.tags
}

output "type" {
  description = "Type of the component"
  value       = data.aws_imagebuilder_component.this.type
}

output "version" {
  description = "Version of the component"
  value       = data.aws_imagebuilder_component.this.version
}