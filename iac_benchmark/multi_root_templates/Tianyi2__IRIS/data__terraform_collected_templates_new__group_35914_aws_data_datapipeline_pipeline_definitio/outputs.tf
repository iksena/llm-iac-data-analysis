output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_datapipeline_pipeline_definition.this.region
}

output "pipeline_id" {
  description = "ID of the pipeline."
  value       = data.aws_datapipeline_pipeline_definition.this.pipeline_id
}

output "parameter_object" {
  description = "Parameter objects used in the pipeline definition."
  value       = data.aws_datapipeline_pipeline_definition.this.parameter_object
}

output "parameter_value" {
  description = "Parameter values used in the pipeline definition."
  value       = data.aws_datapipeline_pipeline_definition.this.parameter_value
}

output "pipeline_object" {
  description = "Objects defined in the pipeline."
  value       = data.aws_datapipeline_pipeline_definition.this.pipeline_object
}