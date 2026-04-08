output "arn" {
  description = "ARN of the App Runner service"
  value       = aws_apprunner_service.this.arn
}

output "service_id" {
  description = "An alphanumeric ID that App Runner generated for this service"
  value       = aws_apprunner_service.this.service_id
}

output "service_url" {
  description = "Subdomain URL that App Runner generated for this service"
  value       = aws_apprunner_service.this.service_url
}

output "status" {
  description = "Current state of the App Runner service"
  value       = aws_apprunner_service.this.status
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider"
  value       = aws_apprunner_service.this.tags_all
}