output "arn" {
  description = "ARN of the FAQ"
  value       = aws_kendra_faq.this.arn
}

output "created_at" {
  description = "The Unix datetime that the FAQ was created"
  value       = aws_kendra_faq.this.created_at
}

output "error_message" {
  description = "When the Status field value is FAILED, this contains a message that explains why"
  value       = aws_kendra_faq.this.error_message
}

output "faq_id" {
  description = "The identifier of the FAQ"
  value       = aws_kendra_faq.this.faq_id
}

output "id" {
  description = "The unique identifiers of the FAQ and index separated by a slash (/)"
  value       = aws_kendra_faq.this.id
}

output "status" {
  description = "The status of the FAQ. It is ready to use when the status is ACTIVE"
  value       = aws_kendra_faq.this.status
}

output "updated_at" {
  description = "The date and time that the FAQ was last updated"
  value       = aws_kendra_faq.this.updated_at
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_kendra_faq.this.tags_all
}