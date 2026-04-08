output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_controltower_controls.this.region
}

output "target_identifier" {
  description = "The ARN of the organizational unit."
  value       = data.aws_controltower_controls.this.target_identifier
}

output "enabled_controls" {
  description = "List of all the ARNs for the controls applied to the target_identifier."
  value       = data.aws_controltower_controls.this.enabled_controls
}