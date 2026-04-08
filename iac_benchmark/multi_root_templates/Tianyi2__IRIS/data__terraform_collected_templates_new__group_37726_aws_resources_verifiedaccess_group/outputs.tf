output "creation_time" {
  description = "Timestamp when the access group was created"
  value       = aws_verifiedaccess_group.this.creation_time
}

output "deletion_time" {
  description = "Timestamp when the access group was deleted"
  value       = aws_verifiedaccess_group.this.deletion_time
}

output "last_updated_time" {
  description = "Timestamp when the access group was last updated"
  value       = aws_verifiedaccess_group.this.last_updated_time
}

output "owner" {
  description = "AWS account number owning this resource"
  value       = aws_verifiedaccess_group.this.owner
}

output "verifiedaccess_group_arn" {
  description = "ARN of this verified access group"
  value       = aws_verifiedaccess_group.this.verifiedaccess_group_arn
}

output "verifiedaccess_group_id" {
  description = "ID of this verified access group"
  value       = aws_verifiedaccess_group.this.verifiedaccess_group_id
}