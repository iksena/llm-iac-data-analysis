output "id" {
  description = "The ID of the GuardDuty invite accepter."
  value       = aws_guardduty_invite_accepter.this.id
}

output "detector_id" {
  description = "The detector ID of the member GuardDuty account."
  value       = aws_guardduty_invite_accepter.this.detector_id
}

output "master_account_id" {
  description = "AWS account ID for primary account."
  value       = aws_guardduty_invite_accepter.this.master_account_id
}