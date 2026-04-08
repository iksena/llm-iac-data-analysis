output "id" {
  description = "The unique identifier (ID) for the Protection object that is created."
  value       = aws_shield_protection.this.id
}

output "arn" {
  description = "The ARN of the Protection."
  value       = aws_shield_protection.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_shield_protection.this.tags_all
}