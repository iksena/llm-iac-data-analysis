output "arn" {
  description = "The ARN of the created AWS IoT Thing Type."
  value       = aws_iot_thing_type.this.arn
}

output "name" {
  description = "The name of the thing type."
  value       = aws_iot_thing_type.this.name
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_iot_thing_type.this.region
}

output "deprecated" {
  description = "Whether the thing type is deprecated."
  value       = aws_iot_thing_type.this.deprecated
}

output "properties" {
  description = "Configuration block containing the properties of the thing type."
  value       = aws_iot_thing_type.this.properties
}

output "tags" {
  description = "Key-value mapping of resource tags."
  value       = aws_iot_thing_type.this.tags
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_iot_thing_type.this.tags_all
}