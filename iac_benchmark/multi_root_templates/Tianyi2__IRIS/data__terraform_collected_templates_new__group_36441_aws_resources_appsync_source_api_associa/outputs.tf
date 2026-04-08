output "arn" {
  description = "ARN of the Source API Association"
  value       = aws_appsync_source_api_association.this.arn
}

output "association_id" {
  description = "ID of the Source API Association"
  value       = aws_appsync_source_api_association.this.association_id
}

output "id" {
  description = "Combined ID of the Source API Association and Merge API"
  value       = aws_appsync_source_api_association.this.id
}