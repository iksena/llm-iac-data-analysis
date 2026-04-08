output "arn" {
  description = "The Amazon Resource Name (ARN) of the Data Integration."
  value       = aws_appintegrations_data_integration.this.arn
}

output "id" {
  description = "The identifier of the Data Integration."
  value       = aws_appintegrations_data_integration.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_appintegrations_data_integration.this.tags_all
}