output "endpoint_id" {
  description = "(Deprecated) The subscriber endpoint to which exception messages are posted."
  value       = aws_securitylake_subscriber_notification.this.endpoint_id
}

output "subscriber_endpoint" {
  description = "The subscriber endpoint to which exception messages are posted."
  value       = aws_securitylake_subscriber_notification.this.subscriber_endpoint
}