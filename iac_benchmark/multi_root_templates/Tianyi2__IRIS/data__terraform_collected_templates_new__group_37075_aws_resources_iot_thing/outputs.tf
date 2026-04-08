output "default_client_id" {
  description = "The default client ID"
  value       = aws_iot_thing.this.default_client_id
}

output "version" {
  description = "The current version of the thing record in the registry"
  value       = aws_iot_thing.this.version
}

output "arn" {
  description = "The ARN of the thing"
  value       = aws_iot_thing.this.arn
}

output "name" {
  description = "The name of the thing"
  value       = aws_iot_thing.this.name
}

output "attributes" {
  description = "Map of attributes of the thing"
  value       = aws_iot_thing.this.attributes
}

output "thing_type_name" {
  description = "The thing type name"
  value       = aws_iot_thing.this.thing_type_name
}