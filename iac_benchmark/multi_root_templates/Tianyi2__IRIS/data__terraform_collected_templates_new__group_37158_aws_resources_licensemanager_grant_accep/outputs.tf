output "id" {
  description = "The grant ARN (Same as arn)."
  value       = aws_licensemanager_grant_accepter.this.id
}

output "arn" {
  description = "The grant ARN."
  value       = aws_licensemanager_grant_accepter.this.id
}

output "name" {
  description = "The Name of the grant."
  value       = aws_licensemanager_grant_accepter.this.name
}

output "allowed_operations" {
  description = "A list of the allowed operations for the grant."
  value       = aws_licensemanager_grant_accepter.this.allowed_operations
}

output "license_arn" {
  description = "The ARN of the license for the grant."
  value       = aws_licensemanager_grant_accepter.this.license_arn
}

output "principal" {
  description = "The target account for the grant."
  value       = aws_licensemanager_grant_accepter.this.principal
}

output "home_region" {
  description = "The home region for the license."
  value       = aws_licensemanager_grant_accepter.this.home_region
}

output "parent_arn" {
  description = "The parent ARN."
  value       = aws_licensemanager_grant_accepter.this.parent_arn
}

output "status" {
  description = "The grant status."
  value       = aws_licensemanager_grant_accepter.this.status
}

output "version" {
  description = "The grant version."
  value       = aws_licensemanager_grant_accepter.this.version
}