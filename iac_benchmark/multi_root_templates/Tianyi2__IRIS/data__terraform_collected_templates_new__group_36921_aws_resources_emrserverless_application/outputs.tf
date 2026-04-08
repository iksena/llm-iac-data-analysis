output "arn" {
  description = "ARN of the cluster"
  value       = aws_emrserverless_application.this.arn
}

output "id" {
  description = "The ID of the cluster"
  value       = aws_emrserverless_application.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_emrserverless_application.this.tags_all
}