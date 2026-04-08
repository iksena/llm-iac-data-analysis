output "id" {
  description = "GameLift Build ID"
  value       = aws_gamelift_build.this.id
}

output "arn" {
  description = "GameLift Build ARN"
  value       = aws_gamelift_build.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_gamelift_build.this.tags_all
}