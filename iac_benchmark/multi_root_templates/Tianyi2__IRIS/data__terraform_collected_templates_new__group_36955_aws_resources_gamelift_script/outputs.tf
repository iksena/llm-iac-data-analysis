output "id" {
  description = "GameLift Script ID"
  value       = aws_gamelift_script.this.id
}

output "arn" {
  description = "GameLift Script ARN"
  value       = aws_gamelift_script.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_gamelift_script.this.tags_all
}