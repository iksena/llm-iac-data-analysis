output "id" {
  description = "The identifier of the client certificate"
  value       = aws_datapipeline_pipeline.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_datapipeline_pipeline.this.tags_all
}