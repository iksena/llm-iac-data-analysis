output "messages_per_second" {
  description = "Messages per second that can be sent."
  value       = aws_pinpoint_email_channel.this.messages_per_second
}

output "application_id" {
  description = "The application ID."
  value       = aws_pinpoint_email_channel.this.application_id
}

output "enabled" {
  description = "Whether the channel is enabled or disabled."
  value       = aws_pinpoint_email_channel.this.enabled
}

output "configuration_set" {
  description = "The ARN of the Amazon SES configuration set that you want to apply to messages that you send through the channel."
  value       = aws_pinpoint_email_channel.this.configuration_set
}

output "from_address" {
  description = "The email address used to send emails from."
  value       = aws_pinpoint_email_channel.this.from_address
}

output "identity" {
  description = "The ARN of an identity verified with SES."
  value       = aws_pinpoint_email_channel.this.identity
}

output "orchestration_sending_role_arn" {
  description = "The ARN of an IAM role for Amazon Pinpoint to use to send email from your campaigns or journeys through Amazon SES."
  value       = aws_pinpoint_email_channel.this.orchestration_sending_role_arn
}

output "role_arn" {
  description = "The ARN of an IAM Role used to submit events to Mobile Analytics' event ingestion service."
  value       = aws_pinpoint_email_channel.this.role_arn
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_pinpoint_email_channel.this.region
}