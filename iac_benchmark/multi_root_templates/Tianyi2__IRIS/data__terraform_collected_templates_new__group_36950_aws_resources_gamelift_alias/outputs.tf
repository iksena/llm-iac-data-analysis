output "id" {
  description = "Alias ID"
  value       = aws_gamelift_alias.this.id
}

output "arn" {
  description = "Alias ARN"
  value       = aws_gamelift_alias.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_gamelift_alias.this.tags_all
}