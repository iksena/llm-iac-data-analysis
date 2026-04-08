output "arn" {
  description = "ARN of the Entity Recognizer version."
  value       = aws_comprehend_entity_recognizer.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_comprehend_entity_recognizer.this.tags_all
}