output "arn" {
  description = "Amazon Resource Name (ARN) of the resource"
  value       = aws_lakeformation_resource.this.arn
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_lakeformation_resource.this.region
}

output "role_arn" {
  description = "Role that has read/write access to the resource"
  value       = aws_lakeformation_resource.this.role_arn
}

output "use_service_linked_role" {
  description = "Whether an IAM service-linked role is used"
  value       = aws_lakeformation_resource.this.use_service_linked_role
}

output "hybrid_access_enabled" {
  description = "Whether AWS LakeFormation hybrid access permission mode is enabled"
  value       = aws_lakeformation_resource.this.hybrid_access_enabled
}

output "with_federation" {
  description = "Whether the resource is a federated resource"
  value       = aws_lakeformation_resource.this.with_federation
}

output "with_privileged_access" {
  description = "Whether the calling principal has permissions to perform all supported Lake Formation operations"
  value       = aws_lakeformation_resource.this.with_privileged_access
}

output "last_modified" {
  description = "Date and time the resource was last modified in RFC 3339 format"
  value       = aws_lakeformation_resource.this.last_modified
}