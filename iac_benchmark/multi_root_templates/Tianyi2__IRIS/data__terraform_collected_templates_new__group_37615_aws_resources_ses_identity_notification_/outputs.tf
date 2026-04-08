output "id" {
  description = "The ID of the SES identity notification topic"
  value       = aws_ses_identity_notification_topic.this.id
}