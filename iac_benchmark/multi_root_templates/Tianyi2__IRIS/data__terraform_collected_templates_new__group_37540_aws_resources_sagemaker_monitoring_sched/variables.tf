variable "name" {
  description = "The name of the monitoring schedule. The name must be unique within an AWS Region within an AWS account. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "monitoring_schedule_config" {
  description = "The configuration object that specifies the monitoring schedule and defines the monitoring job."
  type = object({
    monitoring_job_definition_name = string
    monitoring_type                = string
    schedule_config = optional(object({
      schedule_expression = string
    }))
  })

  validation {
    condition = contains([
      "DataQuality",
      "ModelQuality",
      "ModelBias",
      "ModelExplainability"
    ], var.monitoring_schedule_config.monitoring_type)
    error_message = "resource_aws_sagemaker_monitoring_schedule, monitoring_type must be one of: DataQuality, ModelQuality, ModelBias, or ModelExplainability."
  }

  validation {
    condition     = length(var.monitoring_schedule_config.monitoring_job_definition_name) > 0
    error_message = "resource_aws_sagemaker_monitoring_schedule, monitoring_job_definition_name cannot be empty."
  }

  validation {
    condition     = var.monitoring_schedule_config.schedule_config == null || length(var.monitoring_schedule_config.schedule_config.schedule_expression) > 0
    error_message = "resource_aws_sagemaker_monitoring_schedule, schedule_expression cannot be empty when schedule_config is provided."
  }
}