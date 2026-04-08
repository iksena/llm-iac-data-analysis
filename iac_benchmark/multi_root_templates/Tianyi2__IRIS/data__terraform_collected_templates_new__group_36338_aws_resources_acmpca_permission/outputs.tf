output "certificate_authority_arn" {
  description = "ARN of the CA that grants the permissions"
  value       = aws_acmpca_permission.this.certificate_authority_arn
}

output "actions" {
  description = "Actions that the specified AWS service principal can use"
  value       = aws_acmpca_permission.this.actions
}

output "principal" {
  description = "AWS service or identity that receives the permission"
  value       = aws_acmpca_permission.this.principal
}

output "source_account" {
  description = "ID of the calling account"
  value       = aws_acmpca_permission.this.source_account
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_acmpca_permission.this.region
}

output "policy" {
  description = "IAM policy that is associated with the permission"
  value       = aws_acmpca_permission.this.policy
}