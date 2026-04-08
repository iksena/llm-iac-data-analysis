variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_datapipeline_pipeline_definition, region must be a valid AWS region format."
  }
}

variable "pipeline_id" {
  description = "ID of the pipeline."
  type        = string

  validation {
    condition     = var.pipeline_id != null && var.pipeline_id != ""
    error_message = "data_datapipeline_pipeline_definition, pipeline_id must not be null or empty."
  }
}