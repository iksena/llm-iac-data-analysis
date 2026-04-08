output "id" {
  description = "The name of the EventBridge event bus."
  value       = aws_cloudwatch_event_bus_policy.this.id
}