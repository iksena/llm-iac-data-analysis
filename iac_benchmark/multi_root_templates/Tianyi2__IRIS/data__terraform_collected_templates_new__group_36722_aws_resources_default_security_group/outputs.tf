output "arn" {
  description = "ARN of the security group."
  value       = aws_default_security_group.this.arn
}

output "description" {
  description = "Description of the security group."
  value       = aws_default_security_group.this.description
}

output "id" {
  description = "ID of the security group."
  value       = aws_default_security_group.this.id
}

output "name" {
  description = "Name of the security group."
  value       = aws_default_security_group.this.name
}

output "owner_id" {
  description = "Owner ID."
  value       = aws_default_security_group.this.owner_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_default_security_group.this.tags_all
}