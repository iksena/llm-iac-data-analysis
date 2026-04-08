output "id" {
  description = "The ID of the maintenance window target."
  value       = aws_ssm_maintenance_window_target.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_ssm_maintenance_window_target.this.region
}

output "window_id" {
  description = "The Id of the maintenance window to register the target with."
  value       = aws_ssm_maintenance_window_target.this.window_id
}

output "name" {
  description = "The name of the maintenance window target."
  value       = aws_ssm_maintenance_window_target.this.name
}

output "description" {
  description = "The description of the maintenance window target."
  value       = aws_ssm_maintenance_window_target.this.description
}

output "resource_type" {
  description = "The type of target being registered with the Maintenance Window."
  value       = aws_ssm_maintenance_window_target.this.resource_type
}

output "targets" {
  description = "The targets to register with the maintenance window."
  value       = aws_ssm_maintenance_window_target.this.targets
}

output "owner_information" {
  description = "User-provided value that will be included in any CloudWatch events raised while running tasks for these targets in this Maintenance Window."
  value       = aws_ssm_maintenance_window_target.this.owner_information
}