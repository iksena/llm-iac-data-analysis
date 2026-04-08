output "ids" {
  description = "List of window IDs of the matched SSM maintenance windows"
  value       = data.aws_ssm_maintenance_windows.this.ids
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_ssm_maintenance_windows.this.region
}

output "filter" {
  description = "Configuration block(s) for filtering"
  value       = var.filter
}