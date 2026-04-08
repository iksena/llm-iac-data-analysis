output "event_buses" {
  description = "This list of event buses."
  value       = data.aws_cloudwatch_event_buses.this.event_buses
}

output "arn" {
  description = "The ARN of the event buses."
  value       = [for bus in data.aws_cloudwatch_event_buses.this.event_buses : bus.arn]
}

output "creation_time" {
  description = "The time the event buses were created."
  value       = [for bus in data.aws_cloudwatch_event_buses.this.event_buses : bus.creation_time]
}

output "description" {
  description = "The event buses descriptions."
  value       = [for bus in data.aws_cloudwatch_event_buses.this.event_buses : bus.description]
}

output "last_modified_time" {
  description = "The time the event buses were last modified."
  value       = [for bus in data.aws_cloudwatch_event_buses.this.event_buses : bus.last_modified_time]
}

output "name" {
  description = "The names of the event buses."
  value       = [for bus in data.aws_cloudwatch_event_buses.this.event_buses : bus.name]
}

output "policy" {
  description = "The permissions policies of the event buses, describing which other AWS accounts can write events to these event buses."
  value       = [for bus in data.aws_cloudwatch_event_buses.this.event_buses : bus.policy]
}