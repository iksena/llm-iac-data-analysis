output "arn" {
  description = "ARN of the Email Contact."
  value       = aws_notificationscontacts_email_contact.this.arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_notificationscontacts_email_contact.this.tags_all
}