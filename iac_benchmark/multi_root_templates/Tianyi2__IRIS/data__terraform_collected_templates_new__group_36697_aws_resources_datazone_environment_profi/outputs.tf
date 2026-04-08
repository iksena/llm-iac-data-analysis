output "id" {
  description = "ID of environment profile"
  value       = aws_datazone_environment_profile.this.id
}

output "created_at" {
  description = "Creation time of environment profile"
  value       = aws_datazone_environment_profile.this.created_at
}

output "created_by" {
  description = "Creator of environment profile"
  value       = aws_datazone_environment_profile.this.created_by
}

output "updated_at" {
  description = "Time of last update to environment profile"
  value       = aws_datazone_environment_profile.this.updated_at
}