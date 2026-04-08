output "arn" {
  description = "Amazon Resource Name (ARN) of the data source"
  value       = aws_quicksight_data_source.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_quicksight_data_source.this.tags_all
}