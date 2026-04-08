output "arn" {
  description = "The Amazon Resource Name (ARN) of the document"
  value       = aws_ssm_document.this.arn
}

output "created_date" {
  description = "The date the document was created"
  value       = aws_ssm_document.this.created_date
}

output "default_version" {
  description = "The default version of the document"
  value       = aws_ssm_document.this.default_version
}

output "description" {
  description = "The description of the document"
  value       = aws_ssm_document.this.description
}

output "document_version" {
  description = "The document version"
  value       = aws_ssm_document.this.document_version
}

output "hash_type" {
  description = "The hash type of the document"
  value       = aws_ssm_document.this.hash_type
}

output "hash" {
  description = "The Sha256 or Sha1 hash created by the system when the document was created"
  value       = aws_ssm_document.this.hash
}

output "id" {
  description = "The name of the document"
  value       = aws_ssm_document.this.id
}

output "latest_version" {
  description = "The latest version of the document"
  value       = aws_ssm_document.this.latest_version
}

output "owner" {
  description = "The Amazon Web Services user that created the document"
  value       = aws_ssm_document.this.owner
}

output "parameter" {
  description = "One or more configuration blocks describing the parameters for the document"
  value       = aws_ssm_document.this.parameter
}

output "platform_types" {
  description = "The list of operating system (OS) platforms compatible with this SSM document"
  value       = aws_ssm_document.this.platform_types
}

output "schema_version" {
  description = "The schema version of the document"
  value       = aws_ssm_document.this.schema_version
}

output "status" {
  description = "The status of the SSM document"
  value       = aws_ssm_document.this.status
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_ssm_document.this.tags_all
}