output "arn" {
  description = "Amazon Resource Name (ARN) of the workflow"
  value       = aws_imagebuilder_workflow.this.arn
}

output "date_created" {
  description = "Date the workflow was created"
  value       = aws_imagebuilder_workflow.this.date_created
}

output "owner" {
  description = "Owner of the workflow"
  value       = aws_imagebuilder_workflow.this.owner
}

output "name" {
  description = "Name of the workflow"
  value       = aws_imagebuilder_workflow.this.name
}

output "type" {
  description = "Type of the workflow"
  value       = aws_imagebuilder_workflow.this.type
}

output "version" {
  description = "Version of the workflow"
  value       = aws_imagebuilder_workflow.this.version
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_imagebuilder_workflow.this.region
}

output "change_description" {
  description = "Change description of the workflow"
  value       = aws_imagebuilder_workflow.this.change_description
}

output "data" {
  description = "Inline YAML string with data of the workflow"
  value       = aws_imagebuilder_workflow.this.data
}

output "description" {
  description = "Description of the workflow"
  value       = aws_imagebuilder_workflow.this.description
}

output "kms_key_id" {
  description = "Amazon Resource Name (ARN) of the Key Management Service (KMS) Key used to encrypt the workflow"
  value       = aws_imagebuilder_workflow.this.kms_key_id
}

output "tags" {
  description = "Key-value map of resource tags for the workflow"
  value       = aws_imagebuilder_workflow.this.tags
}

output "uri" {
  description = "S3 URI with data of the workflow"
  value       = aws_imagebuilder_workflow.this.uri
}