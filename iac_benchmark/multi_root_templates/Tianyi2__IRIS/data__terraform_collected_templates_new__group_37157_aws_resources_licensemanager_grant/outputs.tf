output "id" {
  description = "The grant ARN (Same as arn)"
  value       = aws_licensemanager_grant.this.id
}

output "arn" {
  description = "The grant ARN"
  value       = aws_licensemanager_grant.this.arn
}

output "parent_arn" {
  description = "The parent ARN"
  value       = aws_licensemanager_grant.this.parent_arn
}

output "status" {
  description = "The grant status"
  value       = aws_licensemanager_grant.this.status
}

output "version" {
  description = "The grant version"
  value       = aws_licensemanager_grant.this.version
}