output "invitation_id" {
  description = "The ID of the invitation."
  value       = aws_securityhub_invite_accepter.this.invitation_id
}