output "region" {
  description = "Region where this resource is managed."
  value       = aws_guardduty_member.this.region
}

output "account_id" {
  description = "AWS account ID for member account."
  value       = aws_guardduty_member.this.account_id
}

output "detector_id" {
  description = "The detector ID of the GuardDuty account where the member account was created."
  value       = aws_guardduty_member.this.detector_id
}

output "email" {
  description = "Email address for member account."
  value       = aws_guardduty_member.this.email
}

output "invite" {
  description = "Boolean whether the account was invited to GuardDuty as a member."
  value       = aws_guardduty_member.this.invite
}

output "invitation_message" {
  description = "Message for invitation."
  value       = aws_guardduty_member.this.invitation_message
}

output "disable_email_notification" {
  description = "Boolean whether an email notification is sent to the accounts."
  value       = aws_guardduty_member.this.disable_email_notification
}

output "relationship_status" {
  description = "The status of the relationship between the member account and its primary account."
  value       = aws_guardduty_member.this.relationship_status
}