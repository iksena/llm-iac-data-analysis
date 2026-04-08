output "arn" {
  description = "Amazon Resource Name (ARN) of the data set"
  value       = aws_quicksight_data_set.this.arn
}

output "id" {
  description = "A comma-delimited string joining AWS account ID and data set ID"
  value       = aws_quicksight_data_set.this.id
}

output "output_columns" {
  description = "The final set of columns available for use in analyses and dashboards after all data preparation and transformation steps have been applied within the data set"
  value       = aws_quicksight_data_set.this.output_columns
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_quicksight_data_set.this.tags_all
}