output "arn" {
  description = "The Amazon Resource Name (ARN) of the Index."
  value       = aws_kendra_index.this.arn
}

output "created_at" {
  description = "The Unix datetime that the index was created."
  value       = aws_kendra_index.this.created_at
}

output "error_message" {
  description = "When the Status field value is FAILED, this contains a message that explains why."
  value       = aws_kendra_index.this.error_message
}

output "id" {
  description = "The identifier of the Index."
  value       = aws_kendra_index.this.id
}

output "index_statistics" {
  description = "A block that provides information about the number of FAQ questions and answers and the number of text documents indexed."
  value       = aws_kendra_index.this.index_statistics
}

output "status" {
  description = "The current status of the index. When the value is ACTIVE, the index is ready for use."
  value       = aws_kendra_index.this.status
}

output "updated_at" {
  description = "The Unix datetime that the index was last updated."
  value       = aws_kendra_index.this.updated_at
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_kendra_index.this.tags_all
}