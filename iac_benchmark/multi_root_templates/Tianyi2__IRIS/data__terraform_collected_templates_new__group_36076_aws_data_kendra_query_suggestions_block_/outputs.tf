output "arn" {
  description = "ARN of the block list."
  value       = data.aws_kendra_query_suggestions_block_list.this.arn
}

output "created_at" {
  description = "Date-time a block list was created."
  value       = data.aws_kendra_query_suggestions_block_list.this.created_at
}

output "description" {
  description = "Description for the block list."
  value       = data.aws_kendra_query_suggestions_block_list.this.description
}

output "error_message" {
  description = "Error message containing details if there are issues processing the block list."
  value       = data.aws_kendra_query_suggestions_block_list.this.error_message
}

output "file_size_bytes" {
  description = "Current size of the block list text file in S3."
  value       = data.aws_kendra_query_suggestions_block_list.this.file_size_bytes
}

output "id" {
  description = "Unique identifiers of the block list and index separated by a slash (/)."
  value       = data.aws_kendra_query_suggestions_block_list.this.id
}

output "item_count" {
  description = "Current number of valid, non-empty words or phrases in the block list text file."
  value       = data.aws_kendra_query_suggestions_block_list.this.item_count
}

output "name" {
  description = "Name of the block list."
  value       = data.aws_kendra_query_suggestions_block_list.this.name
}

output "role_arn" {
  description = "ARN of a role with permission to access the S3 bucket that contains the block list."
  value       = data.aws_kendra_query_suggestions_block_list.this.role_arn
}

output "source_s3_path" {
  description = "S3 location of the block list input data."
  value       = data.aws_kendra_query_suggestions_block_list.this.source_s3_path
}

output "status" {
  description = "Current status of the block list. When the value is ACTIVE, the block list is ready for use."
  value       = data.aws_kendra_query_suggestions_block_list.this.status
}

output "updated_at" {
  description = "Date and time that the block list was last updated."
  value       = data.aws_kendra_query_suggestions_block_list.this.updated_at
}

output "tags" {
  description = "Metadata that helps organize the block list you create."
  value       = data.aws_kendra_query_suggestions_block_list.this.tags
}