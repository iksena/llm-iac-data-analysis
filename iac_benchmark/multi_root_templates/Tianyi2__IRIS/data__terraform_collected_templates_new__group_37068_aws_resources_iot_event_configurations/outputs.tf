output "id" {
  description = "The ID of the IoT Event Configurations resource"
  value       = aws_iot_event_configurations.this.id
}

output "region" {
  description = "The region where the IoT Event Configurations resource is managed"
  value       = aws_iot_event_configurations.this.region
}

output "event_configurations" {
  description = "The event configuration values"
  value       = aws_iot_event_configurations.this.event_configurations
}