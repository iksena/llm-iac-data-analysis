resource "aws_sagemaker_pipeline" "this" {
  region                = var.region
  pipeline_name         = var.pipeline_name
  pipeline_description  = var.pipeline_description
  pipeline_display_name = var.pipeline_display_name
  pipeline_definition   = var.pipeline_definition
  role_arn              = var.role_arn
  tags                  = var.tags

  dynamic "pipeline_definition_s3_location" {
    for_each = var.pipeline_definition_s3_location != null ? [var.pipeline_definition_s3_location] : []
    content {
      bucket     = pipeline_definition_s3_location.value.bucket
      object_key = pipeline_definition_s3_location.value.object_key
      version_id = pipeline_definition_s3_location.value.version_id
    }
  }

  dynamic "parallelism_configuration" {
    for_each = var.parallelism_configuration != null ? [var.parallelism_configuration] : []
    content {
      max_parallel_execution_steps = parallelism_configuration.value.max_parallel_execution_steps
    }
  }
}