output "arn" {
  description = "The Amazon Resource Name (ARN) of the user"
  value       = aws_connect_user.this.arn
}

output "id" {
  description = "The identifier of the hosting Amazon Connect Instance and identifier of the user separated by a colon (:)"
  value       = aws_connect_user.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_connect_user.this.tags_all
}

output "user_id" {
  description = "The identifier for the user"
  value       = aws_connect_user.this.user_id
}