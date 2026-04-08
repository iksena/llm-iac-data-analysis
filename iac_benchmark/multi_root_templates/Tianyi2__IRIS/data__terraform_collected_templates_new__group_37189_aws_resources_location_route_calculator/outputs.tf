output "calculator_name" {
  description = "The name of the route calculator resource."
  value       = aws_location_route_calculator.this.calculator_name
}

output "data_source" {
  description = "Specifies the data provider of traffic and road network data."
  value       = aws_location_route_calculator.this.data_source
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_location_route_calculator.this.region
}

output "description" {
  description = "The description for the route calculator resource."
  value       = aws_location_route_calculator.this.description
}

output "tags" {
  description = "Key-value tags for the route calculator."
  value       = aws_location_route_calculator.this.tags
}

output "calculator_arn" {
  description = "The Amazon Resource Name (ARN) for the Route calculator resource."
  value       = aws_location_route_calculator.this.calculator_arn
}

output "create_time" {
  description = "The timestamp for when the route calculator resource was created in ISO 8601 format."
  value       = aws_location_route_calculator.this.create_time
}

output "update_time" {
  description = "The timestamp for when the route calculator resource was last update in ISO 8601."
  value       = aws_location_route_calculator.this.update_time
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_location_route_calculator.this.tags_all
}