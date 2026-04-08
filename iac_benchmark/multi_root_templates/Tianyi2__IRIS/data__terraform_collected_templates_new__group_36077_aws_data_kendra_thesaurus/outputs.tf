output "arn" {
  description = "ARN of the Thesaurus."
  value       = data.aws_kendra_thesaurus.this.arn
}

output "created_at" {
  description = "Unix datetime that the Thesaurus was created."
  value       = data.aws_kendra_thesaurus.this.created_at
}

output "description" {
  description = "Description of the Thesaurus."
  value       = data.aws_kendra_thesaurus.this.description
}

output "error_message" {
  description = "When the status field value is FAILED, this contains a message that explains why."
  value       = data.aws_kendra_thesaurus.this.error_message
}

output "file_size_bytes" {
  description = "Size of the Thesaurus file in bytes."
  value       = data.aws_kendra_thesaurus.this.file_size_bytes
}

output "id" {
  description = "Unique identifiers of the Thesaurus and index separated by a slash (/)."
  value       = data.aws_kendra_thesaurus.this.id
}

output "index_id" {
  description = "Identifier of the index that contains the Thesaurus."
  value       = data.aws_kendra_thesaurus.this.index_id
}

output "name" {
  description = "Name of the Thesaurus."
  value       = data.aws_kendra_thesaurus.this.name
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_kendra_thesaurus.this.region
}

output "role_arn" {
  description = "ARN of a role with permission to access the S3 bucket that contains the Thesaurus."
  value       = data.aws_kendra_thesaurus.this.role_arn
}

output "source_s3_path" {
  description = "S3 location of the Thesaurus input data."
  value       = data.aws_kendra_thesaurus.this.source_s3_path
}

output "status" {
  description = "Status of the Thesaurus. It is ready to use when the status is ACTIVE."
  value       = data.aws_kendra_thesaurus.this.status
}

output "synonym_rule_count" {
  description = "Number of synonym rules in the Thesaurus file."
  value       = data.aws_kendra_thesaurus.this.synonym_rule_count
}

output "tags" {
  description = "Metadata that helps organize the Thesaurus you create."
  value       = data.aws_kendra_thesaurus.this.tags
}

output "term_count" {
  description = "Number of unique terms in the Thesaurus file."
  value       = data.aws_kendra_thesaurus.this.term_count
}

output "thesaurus_id" {
  description = "Identifier of the Thesaurus."
  value       = data.aws_kendra_thesaurus.this.thesaurus_id
}

output "updated_at" {
  description = "Date and time that the Thesaurus was last updated."
  value       = data.aws_kendra_thesaurus.this.updated_at
}