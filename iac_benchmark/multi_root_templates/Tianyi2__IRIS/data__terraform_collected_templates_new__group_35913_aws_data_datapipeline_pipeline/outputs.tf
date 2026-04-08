output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_datapipeline_pipeline.this.region
}

output "pipeline_id" {
  description = "ID of the pipeline."
  value       = data.aws_datapipeline_pipeline.this.pipeline_id
}

output "name" {
  description = "Name of Pipeline."
  value       = data.aws_datapipeline_pipeline.this.name
}

output "description" {
  description = "Description of Pipeline."
  value       = data.aws_datapipeline_pipeline.this.description
}

output "tags" {
  description = "Map of tags assigned to the resource."
  value       = data.aws_datapipeline_pipeline.this.tags
}