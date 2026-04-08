output "id" {
  description = "The Id of the data set."
  value       = aws_dataexchange_data_set.this.id
}

output "arn" {
  description = "The Amazon Resource Name of this data set."
  value       = aws_dataexchange_data_set.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_dataexchange_data_set.this.tags_all
}