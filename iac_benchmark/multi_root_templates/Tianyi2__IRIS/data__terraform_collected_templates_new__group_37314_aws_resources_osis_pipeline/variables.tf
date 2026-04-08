variable "pipeline_name" {
  description = "The name of the OpenSearch Ingestion pipeline to create. Pipeline names are unique across the pipelines owned by an account within an AWS Region."
  type        = string

  validation {
    condition     = length(var.pipeline_name) > 0
    error_message = "resource_aws_osis_pipeline, pipeline_name cannot be empty."
  }
}

variable "pipeline_configuration_body" {
  description = "The pipeline configuration in YAML format. This argument accepts the pipeline configuration as a string or within a .yaml file. If you provide the configuration as a string, each new line must be escaped with \\n."
  type        = string

  validation {
    condition     = length(var.pipeline_configuration_body) > 0
    error_message = "resource_aws_osis_pipeline, pipeline_configuration_body cannot be empty."
  }
}

variable "max_units" {
  description = "The maximum pipeline capacity, in Ingestion Compute Units (ICUs)."
  type        = number

  validation {
    condition     = var.max_units > 0
    error_message = "resource_aws_osis_pipeline, max_units must be greater than 0."
  }
}

variable "min_units" {
  description = "The minimum pipeline capacity, in Ingestion Compute Units (ICUs)."
  type        = number

  validation {
    condition     = var.min_units > 0
    error_message = "resource_aws_osis_pipeline, min_units must be greater than 0."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "buffer_options" {
  description = "Key-value pairs to configure persistent buffering for the pipeline."
  type = object({
    persistent_buffer_enabled = bool
  })
  default = null

  validation {
    condition = var.buffer_options == null || (
      var.buffer_options != null && can(var.buffer_options.persistent_buffer_enabled)
    )
    error_message = "resource_aws_osis_pipeline, buffer_options.persistent_buffer_enabled is required when buffer_options is specified."
  }
}

variable "encryption_at_rest_options" {
  description = "Key-value pairs to configure encryption for data that is written to a persistent buffer."
  type = object({
    kms_key_arn = string
  })
  default = null

  validation {
    condition = var.encryption_at_rest_options == null || (
      var.encryption_at_rest_options != null &&
      length(var.encryption_at_rest_options.kms_key_arn) > 0
    )
    error_message = "resource_aws_osis_pipeline, encryption_at_rest_options.kms_key_arn cannot be empty when encryption_at_rest_options is specified."
  }
}

variable "log_publishing_options" {
  description = "Key-value pairs to configure log publishing."
  type = object({
    is_logging_enabled = optional(bool)
    cloudwatch_log_destination = optional(object({
      log_group = string
    }))
  })
  default = null

  validation {
    condition = var.log_publishing_options == null || (
      var.log_publishing_options != null &&
      (var.log_publishing_options.cloudwatch_log_destination == null ||
      length(var.log_publishing_options.cloudwatch_log_destination.log_group) > 0)
    )
    error_message = "resource_aws_osis_pipeline, log_publishing_options.cloudwatch_log_destination.log_group cannot be empty when cloudwatch_log_destination is specified."
  }
}

variable "tags" {
  description = "A map of tags to assign to the pipeline. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "vpc_options" {
  description = "Container for the values required to configure VPC access for the pipeline. If you don't specify these values, OpenSearch Ingestion creates the pipeline with a public endpoint."
  type = object({
    subnet_ids              = list(string)
    security_group_ids      = optional(list(string))
    vpc_endpoint_management = optional(string)
  })
  default = null

  validation {
    condition = var.vpc_options == null || (
      var.vpc_options != null &&
      length(var.vpc_options.subnet_ids) > 0
    )
    error_message = "resource_aws_osis_pipeline, vpc_options.subnet_ids cannot be empty when vpc_options is specified."
  }

  validation {
    condition = var.vpc_options == null || (
      var.vpc_options != null &&
      var.vpc_options.vpc_endpoint_management == null ||
      contains(["CUSTOMER", "SERVICE"], var.vpc_options.vpc_endpoint_management)
    )
    error_message = "resource_aws_osis_pipeline, vpc_options.vpc_endpoint_management must be either 'CUSTOMER' or 'SERVICE'."
  }
}