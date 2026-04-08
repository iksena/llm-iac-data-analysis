output "arn" {
  description = "The ARN of the AppIntegrations Event Integration"
  value       = data.aws_appintegrations_event_integration.this.arn
}

output "description" {
  description = "The description of the Event Integration"
  value       = data.aws_appintegrations_event_integration.this.description
}

output "eventbridge_bus" {
  description = "The EventBridge bus"
  value       = data.aws_appintegrations_event_integration.this.eventbridge_bus
}

output "event_filter" {
  description = "A block that defines the configuration information for the event filter"
  value       = data.aws_appintegrations_event_integration.this.event_filter
}

output "id" {
  description = "The identifier of the Event Integration which is the name of the Event Integration"
  value       = data.aws_appintegrations_event_integration.this.id
}

output "tags" {
  description = "Metadata that you can assign to help organize the report plans you create"
  value       = data.aws_appintegrations_event_integration.this.tags
}