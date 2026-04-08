output "arn" {
  description = "ARN of the resource, an S3 path"
  value       = data.aws_lakeformation_resource.this.arn
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_lakeformation_resource.this.region
}

output "hybrid_access_enabled" {
  description = "Flag to enable AWS LakeFormation hybrid access permission mode"
  value       = data.aws_lakeformation_resource.this.hybrid_access_enabled
}

output "last_modified" {
  description = "Date and time the resource was last modified in RFC 3339 format"
  value       = data.aws_lakeformation_resource.this.last_modified
}

output "role_arn" {
  description = "Role that the resource was registered with"
  value       = data.aws_lakeformation_resource.this.role_arn
}

output "with_federation" {
  description = "Whether the resource is a federated resource"
  value       = data.aws_lakeformation_resource.this.with_federation
}

output "with_privileged_access" {
  description = "Boolean to grant the calling principal the permissions to perform all supported Lake Formation operations on the registered data location"
  value       = data.aws_lakeformation_resource.this.with_privileged_access
}