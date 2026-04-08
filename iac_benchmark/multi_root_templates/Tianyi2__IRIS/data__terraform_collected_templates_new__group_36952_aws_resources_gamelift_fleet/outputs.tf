output "id" {
  description = "Fleet ID."
  value       = aws_gamelift_fleet.this.id
}

output "arn" {
  description = "Fleet ARN."
  value       = aws_gamelift_fleet.this.arn
}

output "build_arn" {
  description = "Build ARN."
  value       = aws_gamelift_fleet.this.build_arn
}

output "operating_system" {
  description = "Operating system of the fleet's computing resources."
  value       = aws_gamelift_fleet.this.operating_system
}

output "script_arn" {
  description = "Script ARN."
  value       = aws_gamelift_fleet.this.script_arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_gamelift_fleet.this.tags_all
}