output "id" {
  description = "Unique identifier for the Dev Environment"
  value       = aws_codecatalyst_dev_environment.this.id
}

output "space_name" {
  description = "The name of the space"
  value       = aws_codecatalyst_dev_environment.this.space_name
}

output "project_name" {
  description = "The name of the project in the space"
  value       = aws_codecatalyst_dev_environment.this.project_name
}

output "instance_type" {
  description = "The Amazon EC2 instace type to use for the Dev Environment"
  value       = aws_codecatalyst_dev_environment.this.instance_type
}

output "alias" {
  description = "The alias for the Dev Environment"
  value       = aws_codecatalyst_dev_environment.this.alias
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_codecatalyst_dev_environment.this.region
}

output "inactivity_timeout_minutes" {
  description = "The amount of time the Dev Environment will run without any activity detected before stopping, in minutes"
  value       = aws_codecatalyst_dev_environment.this.inactivity_timeout_minutes
}

output "persistent_storage" {
  description = "Information about the amount of storage allocated to the Dev Environment"
  value       = aws_codecatalyst_dev_environment.this.persistent_storage
}

output "ides" {
  description = "Information about the integrated development environment (IDE) configured for a Dev Environment"
  value       = aws_codecatalyst_dev_environment.this.ides
}

output "repositories" {
  description = "The source repository that contains the branch to clone into the Dev Environment"
  value       = aws_codecatalyst_dev_environment.this.repositories
}