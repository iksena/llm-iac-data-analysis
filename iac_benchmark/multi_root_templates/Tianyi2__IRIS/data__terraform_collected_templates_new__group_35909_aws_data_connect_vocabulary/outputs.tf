output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_connect_vocabulary.this.region
}

output "instance_id" {
  description = "Reference to the hosting Amazon Connect Instance"
  value       = data.aws_connect_vocabulary.this.instance_id
}

output "name" {
  description = "Name of the Vocabulary"
  value       = data.aws_connect_vocabulary.this.name
}

output "vocabulary_id" {
  description = "The identifier of the custom vocabulary"
  value       = data.aws_connect_vocabulary.this.vocabulary_id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of the Vocabulary"
  value       = data.aws_connect_vocabulary.this.arn
}

output "content" {
  description = "The content of the custom vocabulary in plain-text format with a table of values"
  value       = data.aws_connect_vocabulary.this.content
}

output "failure_reason" {
  description = "The reason why the custom vocabulary was not created"
  value       = data.aws_connect_vocabulary.this.failure_reason
}

output "id" {
  description = "The identifier of the hosting Amazon Connect Instance and identifier of the vocabulary separated by a colon (:)"
  value       = data.aws_connect_vocabulary.this.id
}

output "language_code" {
  description = "The language code of the vocabulary entries"
  value       = data.aws_connect_vocabulary.this.language_code
}

output "last_modified_time" {
  description = "The timestamp when the custom vocabulary was last modified"
  value       = data.aws_connect_vocabulary.this.last_modified_time
}

output "state" {
  description = "The current state of the custom vocabulary"
  value       = data.aws_connect_vocabulary.this.state
}

output "tags" {
  description = "A map of tags assigned to the Vocabulary"
  value       = data.aws_connect_vocabulary.this.tags
}