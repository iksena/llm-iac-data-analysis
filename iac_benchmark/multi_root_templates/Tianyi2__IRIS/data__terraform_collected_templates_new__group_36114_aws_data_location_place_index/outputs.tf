output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_location_place_index.this.region
}

output "index_name" {
  description = "Name of the place index resource."
  value       = data.aws_location_place_index.this.index_name
}

output "create_time" {
  description = "Timestamp for when the place index resource was created in ISO 8601 format."
  value       = data.aws_location_place_index.this.create_time
}

output "data_source" {
  description = "Data provider of geospatial data."
  value       = data.aws_location_place_index.this.data_source
}

output "data_source_configuration" {
  description = "List of configurations that specify data storage option for requesting Places."
  value       = data.aws_location_place_index.this.data_source_configuration
}

output "description" {
  description = "Optional description for the place index resource."
  value       = data.aws_location_place_index.this.description
}

output "index_arn" {
  description = "ARN for the place index resource."
  value       = data.aws_location_place_index.this.index_arn
}

output "tags" {
  description = "Key-value map of resource tags for the place index."
  value       = data.aws_location_place_index.this.tags
}

output "update_time" {
  description = "Timestamp for when the place index resource was last updated in ISO 8601 format."
  value       = data.aws_location_place_index.this.update_time
}