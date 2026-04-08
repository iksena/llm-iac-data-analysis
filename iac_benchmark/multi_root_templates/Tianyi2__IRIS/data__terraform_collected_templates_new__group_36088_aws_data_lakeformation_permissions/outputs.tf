output "permissions" {
  description = "List of permissions granted to the principal. For details on permissions, see Lake Formation Permissions Reference."
  value       = data.aws_lakeformation_permissions.this.permissions
}

output "permissions_with_grant_option" {
  description = "Subset of permissions which the principal can pass."
  value       = data.aws_lakeformation_permissions.this.permissions_with_grant_option
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_lakeformation_permissions.this.region
}

output "principal" {
  description = "Principal to be granted the permissions on the resource."
  value       = data.aws_lakeformation_permissions.this.principal
}

output "catalog_id" {
  description = "Identifier for the Data Catalog."
  value       = data.aws_lakeformation_permissions.this.catalog_id
}

output "catalog_resource" {
  description = "Whether the permissions are to be granted for the Data Catalog."
  value       = data.aws_lakeformation_permissions.this.catalog_resource
}