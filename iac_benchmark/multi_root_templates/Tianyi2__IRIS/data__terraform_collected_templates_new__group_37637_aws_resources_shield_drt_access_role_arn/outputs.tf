output "id" {
  description = "The ID of the Shield DRT access role ARN association (AWS account ID)"
  value       = aws_shield_drt_access_role_arn_association.this.id
}

output "role_arn" {
  description = "The Amazon Resource Name (ARN) of the role associated with the SRT"
  value       = aws_shield_drt_access_role_arn_association.this.role_arn
}