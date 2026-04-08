output "arn" {
  description = "The Amazon Resource Name (ARN) of the vocabulary"
  value       = aws_connect_vocabulary.this.arn
}

output "failure_reason" {
  description = "The reason why the custom vocabulary was not created"
  value       = aws_connect_vocabulary.this.failure_reason
}

output "id" {
  description = "The identifier of the hosting Amazon Connect Instance and identifier of the vocabulary separated by a colon (:)"
  value       = aws_connect_vocabulary.this.id
}

output "last_modified_time" {
  description = "The timestamp when the custom vocabulary was last modified"
  value       = aws_connect_vocabulary.this.last_modified_time
}

output "state" {
  description = "The current state of the custom vocabulary. Valid values are CREATION_IN_PROGRESS, ACTIVE, CREATION_FAILED, DELETE_IN_PROGRESS"
  value       = aws_connect_vocabulary.this.state
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_connect_vocabulary.this.tags_all
}

output "vocabulary_id" {
  description = "The identifier of the custom vocabulary"
  value       = aws_connect_vocabulary.this.vocabulary_id
}