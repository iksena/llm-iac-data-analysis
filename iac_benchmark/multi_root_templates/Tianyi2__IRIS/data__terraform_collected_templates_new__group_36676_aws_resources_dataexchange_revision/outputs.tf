output "id" {
  description = "The Id of the data set"
  value       = aws_dataexchange_revision.this.id
}

output "revision_id" {
  description = "The Id of the revision"
  value       = aws_dataexchange_revision.this.revision_id
}

output "arn" {
  description = "The Amazon Resource Name of this data set"
  value       = aws_dataexchange_revision.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_dataexchange_revision.this.tags_all
}