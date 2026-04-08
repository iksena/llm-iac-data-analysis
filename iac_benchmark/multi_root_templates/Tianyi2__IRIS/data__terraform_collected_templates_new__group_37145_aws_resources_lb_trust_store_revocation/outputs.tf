output "revocation_id" {
  description = "AWS assigned RevocationId, (number)."
  value       = aws_lb_trust_store_revocation.this.revocation_id
}

output "id" {
  description = "Combination of the Trust Store ARN and RevocationId."
  value       = aws_lb_trust_store_revocation.this.id
}