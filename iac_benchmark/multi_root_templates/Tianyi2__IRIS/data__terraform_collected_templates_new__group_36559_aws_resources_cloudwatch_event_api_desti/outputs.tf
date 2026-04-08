output "arn" {
  description = "The Amazon Resource Name (ARN) of the event API Destination."
  value       = aws_cloudwatch_event_api_destination.this.arn
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_cloudwatch_event_api_destination.this.region
}

output "name" {
  description = "The name of the API Destination."
  value       = aws_cloudwatch_event_api_destination.this.name
}

output "description" {
  description = "The description of the API Destination."
  value       = aws_cloudwatch_event_api_destination.this.description
}

output "invocation_endpoint" {
  description = "URL endpoint to invoke as a target."
  value       = aws_cloudwatch_event_api_destination.this.invocation_endpoint
}

output "http_method" {
  description = "The HTTP method used for the invocation endpoint."
  value       = aws_cloudwatch_event_api_destination.this.http_method
}

output "invocation_rate_limit_per_second" {
  description = "The maximum number of invocations per second allowed for this destination."
  value       = aws_cloudwatch_event_api_destination.this.invocation_rate_limit_per_second
}

output "connection_arn" {
  description = "ARN of the EventBridge Connection used for the API Destination."
  value       = aws_cloudwatch_event_api_destination.this.connection_arn
}