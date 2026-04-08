output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_codecatalyst_dev_environment.this.region
}

output "env_id" {
  description = "The system-generated unique ID of the Dev Environment."
  value       = data.aws_codecatalyst_dev_environment.this.env_id
}

output "project_name" {
  description = "The name of the project in the space."
  value       = data.aws_codecatalyst_dev_environment.this.project_name
}

output "space_name" {
  description = "The name of the space."
  value       = data.aws_codecatalyst_dev_environment.this.space_name
}

output "alias" {
  description = "The user-specified alias for the Dev Environment."
  value       = data.aws_codecatalyst_dev_environment.this.alias
}

output "creator_id" {
  description = "The system-generated unique ID of the user who created the Dev Environment."
  value       = data.aws_codecatalyst_dev_environment.this.creator_id
}

output "ides" {
  description = "Information about the integrated development environment (IDE) configured for a Dev Environment."
  value       = data.aws_codecatalyst_dev_environment.this.ides
}

output "inactivity_timeout_minutes" {
  description = "The amount of time the Dev Environment will run without any activity detected before stopping, in minutes."
  value       = data.aws_codecatalyst_dev_environment.this.inactivity_timeout_minutes
}

output "instance_type" {
  description = "The Amazon EC2 instace type to use for the Dev Environment."
  value       = data.aws_codecatalyst_dev_environment.this.instance_type
}

output "last_updated_time" {
  description = "The time when the Dev Environment was last updated, in coordinated universal time (UTC) timestamp format."
  value       = data.aws_codecatalyst_dev_environment.this.last_updated_time
}

output "persistent_storage" {
  description = "Information about the amount of storage allocated to the Dev Environment."
  value       = data.aws_codecatalyst_dev_environment.this.persistent_storage
}

output "repositories" {
  description = "The source repository that contains the branch to clone into the Dev Environment."
  value       = data.aws_codecatalyst_dev_environment.this.repositories
}

output "status" {
  description = "The current status of the Dev Environment."
  value       = data.aws_codecatalyst_dev_environment.this.status
}

output "status_reason" {
  description = "The reason for the status."
  value       = data.aws_codecatalyst_dev_environment.this.status_reason
}