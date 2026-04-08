variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_datapipeline_pipeline, region must be a valid AWS region name."
  }
}

variable "pipeline_id" {
  description = "ID of the pipeline."
  type        = string

  validation {
    condition     = can(regex("^.+$", var.pipeline_id))
    error_message = "data_aws_datapipeline_pipeline, pipeline_id cannot be empty."
  }
}