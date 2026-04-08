output "arn" {
  description = "The license configuration ARN."
  value       = aws_licensemanager_license_configuration.this.arn
}

output "id" {
  description = "The license configuration ARN."
  value       = aws_licensemanager_license_configuration.this.id
}

output "owner_account_id" {
  description = "Account ID of the owner of the license configuration."
  value       = aws_licensemanager_license_configuration.this.owner_account_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_licensemanager_license_configuration.this.tags_all
}