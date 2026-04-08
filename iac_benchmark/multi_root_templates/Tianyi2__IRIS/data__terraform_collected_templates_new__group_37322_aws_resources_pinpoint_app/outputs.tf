output "application_id" {
  description = "The Application ID of the Pinpoint App"
  value       = aws_pinpoint_app.this.application_id
}

output "arn" {
  description = "Amazon Resource Name (ARN) of the PinPoint Application"
  value       = aws_pinpoint_app.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_pinpoint_app.this.tags_all
}