variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "commitment_duration" {
  description = "Commitment duration requested for the Provisioned Throughput. For custom models, you can purchase on-demand Provisioned Throughput by omitting this argument."
  type        = string
  default     = null

  validation {
    condition     = var.commitment_duration == null || contains(["OneMonth", "SixMonths"], var.commitment_duration)
    error_message = "resource_aws_bedrock_provisioned_model_throughput, commitment_duration must be either 'OneMonth' or 'SixMonths'."
  }
}

variable "model_arn" {
  description = "ARN of the model to associate with this Provisioned Throughput."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:bedrock:", var.model_arn))
    error_message = "resource_aws_bedrock_provisioned_model_throughput, model_arn must be a valid Bedrock model ARN."
  }
}

variable "model_units" {
  description = "Number of model units to allocate. A model unit delivers a specific throughput level for the specified model."
  type        = number

  validation {
    condition     = var.model_units > 0
    error_message = "resource_aws_bedrock_provisioned_model_throughput, model_units must be greater than 0."
  }
}

variable "provisioned_model_name" {
  description = "Unique name for this Provisioned Throughput."
  type        = string

  validation {
    condition     = length(var.provisioned_model_name) > 0
    error_message = "resource_aws_bedrock_provisioned_model_throughput, provisioned_model_name cannot be empty."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "create_timeout" {
  description = "Timeout for creating the resource."
  type        = string
  default     = "10m"
}