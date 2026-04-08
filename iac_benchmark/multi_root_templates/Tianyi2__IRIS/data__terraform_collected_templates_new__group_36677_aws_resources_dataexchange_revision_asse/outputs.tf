output "arn" {
  description = "The ARN of the Data Exchange Revision Assets"
  value       = aws_dataexchange_revision_assets.this.arn
}

output "id" {
  description = "The unique identifier for the revision"
  value       = aws_dataexchange_revision_assets.this.id
}

output "created_at" {
  description = "The timestamp when the revision was created, in RFC3339 format"
  value       = aws_dataexchange_revision_assets.this.created_at
}

output "updated_at" {
  description = "The timestamp when the revision was last updated, in RFC3339 format"
  value       = aws_dataexchange_revision_assets.this.updated_at
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_dataexchange_revision_assets.this.tags_all
}