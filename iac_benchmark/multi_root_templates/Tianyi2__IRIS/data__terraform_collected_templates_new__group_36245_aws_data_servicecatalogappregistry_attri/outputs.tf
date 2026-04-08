output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_servicecatalogappregistry_attribute_group.this.region
}

output "arn" {
  description = "ARN of the Attribute Group."
  value       = data.aws_servicecatalogappregistry_attribute_group.this.arn
}

output "id" {
  description = "ID of the Attribute Group."
  value       = data.aws_servicecatalogappregistry_attribute_group.this.id
}

output "name" {
  description = "Name of the Attribute Group."
  value       = data.aws_servicecatalogappregistry_attribute_group.this.name
}

output "attributes" {
  description = "A JSON string of nested key-value pairs that represents the attributes of the group."
  value       = data.aws_servicecatalogappregistry_attribute_group.this.attributes
}

output "description" {
  description = "Description of the Attribute Group."
  value       = data.aws_servicecatalogappregistry_attribute_group.this.description
}

output "tags" {
  description = "A map of tags assigned to the Attribute Group."
  value       = data.aws_servicecatalogappregistry_attribute_group.this.tags
}