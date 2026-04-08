output "vdm_enabled" {
  description = "The status of the VDM configuration"
  value       = aws_sesv2_account_vdm_attributes.this.vdm_enabled
}

output "region" {
  description = "The region where the resource is managed"
  value       = aws_sesv2_account_vdm_attributes.this.region
}

output "dashboard_attributes" {
  description = "The VDM dashboard attributes configuration"
  value       = aws_sesv2_account_vdm_attributes.this.dashboard_attributes
}

output "guardian_attributes" {
  description = "The VDM guardian attributes configuration"
  value       = aws_sesv2_account_vdm_attributes.this.guardian_attributes
}

output "id" {
  description = "The resource identifier"
  value       = aws_sesv2_account_vdm_attributes.this.id
}