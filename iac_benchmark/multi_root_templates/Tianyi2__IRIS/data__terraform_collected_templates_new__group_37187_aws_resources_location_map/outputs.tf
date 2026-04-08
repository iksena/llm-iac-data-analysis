output "map_name" {
  description = "The name for the map resource."
  value       = aws_location_map.this.map_name
}

output "configuration" {
  description = "Configuration block with the map style selected from an available data provider."
  value       = aws_location_map.this.configuration
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_location_map.this.region
}

output "description" {
  description = "Description for the map resource."
  value       = aws_location_map.this.description
}

output "tags" {
  description = "Key-value tags for the map."
  value       = aws_location_map.this.tags
}

output "create_time" {
  description = "The timestamp for when the map resource was created in ISO 8601 format."
  value       = aws_location_map.this.create_time
}

output "map_arn" {
  description = "The Amazon Resource Name (ARN) for the map resource. Used to specify a resource across all AWS."
  value       = aws_location_map.this.map_arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_location_map.this.tags_all
}

output "update_time" {
  description = "The timestamp for when the map resource was last updated in ISO 8601 format."
  value       = aws_location_map.this.update_time
}