output "arn" {
  description = "The ARN of the endpoint that was created"
  value       = aws_cloudwatch_event_endpoint.this.arn
}

output "endpoint_url" {
  description = "The URL of the endpoint that was created"
  value       = aws_cloudwatch_event_endpoint.this.endpoint_url
}