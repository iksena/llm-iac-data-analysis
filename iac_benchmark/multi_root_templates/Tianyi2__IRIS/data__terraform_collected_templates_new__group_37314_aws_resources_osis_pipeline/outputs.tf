output "id" {
  description = "Unique identifier for the pipeline."
  value       = aws_osis_pipeline.this.id
}

output "ingest_endpoint_urls" {
  description = "The list of ingestion endpoints for the pipeline, which you can send data to."
  value       = aws_osis_pipeline.this.ingest_endpoint_urls
}

output "pipeline_arn" {
  description = "Amazon Resource Name (ARN) of the pipeline."
  value       = aws_osis_pipeline.this.pipeline_arn
}