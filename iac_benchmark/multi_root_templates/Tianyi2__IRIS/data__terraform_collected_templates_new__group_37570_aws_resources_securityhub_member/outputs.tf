output "id" {
  description = "The ID of the member AWS account (matches account_id)."
  value       = aws_securityhub_member.this.id
}

output "master_id" {
  description = "The ID of the master Security Hub AWS account."
  value       = aws_securityhub_member.this.master_id
}

output "member_status" {
  description = "The status of the member account relationship."
  value       = aws_securityhub_member.this.member_status
}