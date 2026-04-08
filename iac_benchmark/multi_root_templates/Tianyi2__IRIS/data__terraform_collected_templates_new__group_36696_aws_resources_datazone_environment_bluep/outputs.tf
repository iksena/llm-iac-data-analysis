
output "domain_id" {
  description = "ID of the Domain"
  value       = aws_datazone_environment_blueprint_configuration.this.domain_id
}

output "environment_blueprint_id" {
  description = "ID of the Environment Blueprint"
  value       = aws_datazone_environment_blueprint_configuration.this.environment_blueprint_id
}

output "enabled_regions" {
  description = "Regions in which the blueprint is enabled"
  value       = aws_datazone_environment_blueprint_configuration.this.enabled_regions
}

output "manage_access_role_arn" {
  description = "ARN of the manage access role with which this blueprint is created"
  value       = aws_datazone_environment_blueprint_configuration.this.manage_access_role_arn
}

output "provisioning_role_arn" {
  description = "ARN of the provisioning role with which this blueprint is created"
  value       = aws_datazone_environment_blueprint_configuration.this.provisioning_role_arn
}

output "regional_parameters" {
  description = "Parameters for each region in which the blueprint is enabled"
  value       = aws_datazone_environment_blueprint_configuration.this.regional_parameters
}