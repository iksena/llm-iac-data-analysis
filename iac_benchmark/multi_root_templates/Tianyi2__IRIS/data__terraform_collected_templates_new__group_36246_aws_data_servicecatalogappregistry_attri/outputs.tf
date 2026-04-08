output "attribute_group_ids" {
  description = "Set of attribute group IDs this application is associated with."
  value       = data.aws_servicecatalogappregistry_attribute_group_associations.this.attribute_group_ids
}

output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_servicecatalogappregistry_attribute_group_associations.this.region
}

output "id" {
  description = "ID of the application to which attribute groups are associated."
  value       = data.aws_servicecatalogappregistry_attribute_group_associations.this.id
}

output "name" {
  description = "Name of the application to which attribute groups are associated."
  value       = data.aws_servicecatalogappregistry_attribute_group_associations.this.name
}