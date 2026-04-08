output "arn" {
  description = "Amazon Resource Name (ARN) of the configuration"
  value       = aws_msk_configuration.this.arn
}

output "latest_revision" {
  description = "Latest revision of the configuration"
  value       = aws_msk_configuration.this.latest_revision
}

output "name" {
  description = "Name of the configuration"
  value       = aws_msk_configuration.this.name
}

output "description" {
  description = "Description of the configuration"
  value       = aws_msk_configuration.this.description
}

output "kafka_versions" {
  description = "List of Apache Kafka versions which can use this configuration"
  value       = aws_msk_configuration.this.kafka_versions
}

output "server_properties" {
  description = "Contents of the server.properties file"
  value       = aws_msk_configuration.this.server_properties
}