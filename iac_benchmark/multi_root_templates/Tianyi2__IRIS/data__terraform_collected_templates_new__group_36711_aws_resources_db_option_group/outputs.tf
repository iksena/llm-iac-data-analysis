output "id" {
  description = "DB option group name."
  value       = aws_db_option_group.this.id
}

output "arn" {
  description = "ARN of the DB option group."
  value       = aws_db_option_group.this.arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_db_option_group.this.tags_all
}