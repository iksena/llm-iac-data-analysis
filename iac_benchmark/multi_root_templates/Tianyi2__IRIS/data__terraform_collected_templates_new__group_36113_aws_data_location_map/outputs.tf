output "region" {
  description = "Region where this resource will be managed"
  value       = data.aws_location_map.this.region
}

output "map_name" {
  description = "Name of the map resource"
  value       = data.aws_location_map.this.map_name
}

output "configuration" {
  description = "List of configurations that specify the map tile style selected from a partner data provider"
  value       = data.aws_location_map.this.configuration
}

output "create_time" {
  description = "Timestamp for when the map resource was created in ISO 8601 format"
  value       = data.aws_location_map.this.create_time
}

output "description" {
  description = "Optional description for the map resource"
  value       = data.aws_location_map.this.description
}

output "map_arn" {
  description = "ARN for the map resource"
  value       = data.aws_location_map.this.map_arn
}

output "tags" {
  description = "Key-value map of resource tags for the map"
  value       = data.aws_location_map.this.tags
}

output "update_time" {
  description = "Timestamp for when the map resource was last updated in ISO 8601 format"
  value       = data.aws_location_map.this.update_time
}