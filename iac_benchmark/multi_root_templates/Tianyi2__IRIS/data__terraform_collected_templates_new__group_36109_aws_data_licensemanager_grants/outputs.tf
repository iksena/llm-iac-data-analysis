output "arns" {
  description = "List of all the license grant ARNs found"
  value       = data.aws_licensemanager_grants.this.arns
}