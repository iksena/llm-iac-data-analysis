output "arn" {
  description = "ARN of the FAQ."
  value       = data.aws_kendra_faq.this.arn
}

output "created_at" {
  description = "Unix datetime that the faq was created."
  value       = data.aws_kendra_faq.this.created_at
}

output "description" {
  description = "Description of the FAQ."
  value       = data.aws_kendra_faq.this.description
}

output "error_message" {
  description = "When the status field value is FAILED, this contains a message that explains why."
  value       = data.aws_kendra_faq.this.error_message
}

output "file_format" {
  description = "File format used by the input files for the FAQ. Valid Values are CSV, CSV_WITH_HEADER, JSON."
  value       = data.aws_kendra_faq.this.file_format
}

output "id" {
  description = "Unique identifiers of the FAQ and index separated by a slash (/)."
  value       = data.aws_kendra_faq.this.id
}

output "language_code" {
  description = "Code for a language. This shows a supported language for the FAQ document."
  value       = data.aws_kendra_faq.this.language_code
}

output "name" {
  description = "Name of the FAQ."
  value       = data.aws_kendra_faq.this.name
}

output "role_arn" {
  description = "ARN of a role with permission to access the S3 bucket that contains the FAQs."
  value       = data.aws_kendra_faq.this.role_arn
}

output "s3_path" {
  description = "S3 location of the FAQ input data."
  value       = data.aws_kendra_faq.this.s3_path
}

output "s3_path_bucket" {
  description = "Name of the S3 bucket that contains the file."
  value       = length(data.aws_kendra_faq.this.s3_path) > 0 ? data.aws_kendra_faq.this.s3_path[0].bucket : null
}

output "s3_path_key" {
  description = "Name of the file."
  value       = length(data.aws_kendra_faq.this.s3_path) > 0 ? data.aws_kendra_faq.this.s3_path[0].key : null
}

output "status" {
  description = "Status of the FAQ. It is ready to use when the status is ACTIVE."
  value       = data.aws_kendra_faq.this.status
}

output "updated_at" {
  description = "Date and time that the FAQ was last updated."
  value       = data.aws_kendra_faq.this.updated_at
}

output "tags" {
  description = "Metadata that helps organize the FAQs you create."
  value       = data.aws_kendra_faq.this.tags
}