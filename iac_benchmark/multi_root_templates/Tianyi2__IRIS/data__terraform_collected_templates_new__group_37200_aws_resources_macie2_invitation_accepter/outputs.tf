output "id" {
  description = "The unique identifier (ID) of the macie invitation accepter"
  value       = aws_macie2_invitation_accepter.this.id
}

output "invitation_id" {
  description = "The unique identifier for the invitation"
  value       = aws_macie2_invitation_accepter.this.invitation_id
}