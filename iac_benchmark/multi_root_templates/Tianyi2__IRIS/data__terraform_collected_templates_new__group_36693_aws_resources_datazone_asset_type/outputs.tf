output "domain_identifier" {
  description = "The unique identifier of the Amazon DataZone domain where the custom asset type is being created."
  value       = aws_datazone_asset_type.this.domain_identifier
}

output "name" {
  description = "The name of the custom asset type."
  value       = aws_datazone_asset_type.this.name
}

output "owning_project_identifier" {
  description = "The unique identifier of the Amazon DataZone project that owns the custom asset type."
  value       = aws_datazone_asset_type.this.owning_project_identifier
}

output "region" {
  description = "Region where this resource will be managed."
  value       = aws_datazone_asset_type.this.region
}

output "description" {
  description = "The description of the custom asset type."
  value       = aws_datazone_asset_type.this.description
}

output "forms_input" {
  description = "The metadata forms that are to be attached to the custom asset type."
  value       = aws_datazone_asset_type.this.forms_input
}

output "created_at" {
  description = "The timestamp when the custom asset type was created."
  value       = aws_datazone_asset_type.this.created_at
}

output "created_by" {
  description = "The user who created the custom asset type."
  value       = aws_datazone_asset_type.this.created_by
}

output "revision" {
  description = "The revision of the asset type."
  value       = aws_datazone_asset_type.this.revision
}