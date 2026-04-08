output "calculator_arn" {
  description = "ARN for the Route calculator resource. Use the ARN when you specify a resource across AWS"
  value       = data.aws_location_route_calculator.this.calculator_arn
}

output "calculator_name" {
  description = "Name of the route calculator resource"
  value       = data.aws_location_route_calculator.this.calculator_name
}

output "create_time" {
  description = "Timestamp for when the route calculator resource was created in ISO 8601 format"
  value       = data.aws_location_route_calculator.this.create_time
}

output "data_source" {
  description = "Data provider of traffic and road network data"
  value       = data.aws_location_route_calculator.this.data_source
}

output "description" {
  description = "Optional description of the route calculator resource"
  value       = data.aws_location_route_calculator.this.description
}

output "region" {
  description = "Region where this resource will be managed"
  value       = data.aws_location_route_calculator.this.region
}

output "tags" {
  description = "Key-value map of resource tags for the route calculator"
  value       = data.aws_location_route_calculator.this.tags
}

output "update_time" {
  description = "Timestamp for when the route calculator resource was last updated in ISO 8601 format"
  value       = data.aws_location_route_calculator.this.update_time
}