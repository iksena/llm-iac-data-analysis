output "id" {
  description = "The ID of the VPC connection notification."
  value       = aws_vpc_endpoint_connection_notification.this.id
}

output "state" {
  description = "The state of the notification."
  value       = aws_vpc_endpoint_connection_notification.this.state
}

output "notification_type" {
  description = "The type of notification."
  value       = aws_vpc_endpoint_connection_notification.this.notification_type
}