output "arn" {
  description = "ARN of the document. If the document is an AWS managed document, this value will be set to the name of the document instead."
  value       = data.aws_ssm_document.this.arn
}

output "content" {
  description = "The content for the SSM document in JSON or YAML format."
  value       = data.aws_ssm_document.this.content
}

output "document_type" {
  description = "The type of the document."
  value       = data.aws_ssm_document.this.document_type
}

output "name" {
  description = "The name of the document."
  value       = data.aws_ssm_document.this.name
}

output "document_format" {
  description = "The format of the document."
  value       = data.aws_ssm_document.this.document_format
}

output "document_version" {
  description = "The document version."
  value       = data.aws_ssm_document.this.document_version
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_ssm_document.this.region
}