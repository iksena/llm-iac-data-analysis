output "id" {
  description = "The unique identifier (ID) of the macie custom data identifier."
  value       = aws_macie2_custom_data_identifier.this.id
}


output "created_at" {
  description = "The date and time, in UTC and extended RFC 3339 format, when the Amazon Macie account was created."
  value       = aws_macie2_custom_data_identifier.this.created_at
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of the custom data identifier."
  value       = aws_macie2_custom_data_identifier.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_macie2_custom_data_identifier.this.tags_all
}