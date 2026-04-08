output "arns" {
  description = "List of all the license ARNs found."
  value       = data.aws_licensemanager_received_licenses.this.arns
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_licensemanager_received_licenses.this.region
}

output "filter" {
  description = "Filter configuration used to query the received licenses."
  value       = var.filter
}