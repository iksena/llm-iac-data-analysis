output "id" {
  description = "The ID of the Inspector2 Enabler resource"
  value       = aws_inspector2_enabler.this.id
}

output "region" {
  description = "The region where the Inspector2 Enabler is configured"
  value       = aws_inspector2_enabler.this.region
}

output "account_ids" {
  description = "The set of account IDs for which Inspector2 is enabled"
  value       = aws_inspector2_enabler.this.account_ids
}

output "resource_types" {
  description = "The set of resource types being scanned"
  value       = aws_inspector2_enabler.this.resource_types
}