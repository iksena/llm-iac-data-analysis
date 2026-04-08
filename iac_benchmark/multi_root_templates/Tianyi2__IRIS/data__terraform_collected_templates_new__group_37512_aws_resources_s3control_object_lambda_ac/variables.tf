variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "account_id" {
  description = "The AWS account ID for the owner of the bucket for which you want to create an Object Lambda Access Point"
  type        = string
  default     = null
}

variable "name" {
  description = "The name for this Object Lambda Access Point"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_s3control_object_lambda_access_point, name must not be empty."
  }
}

variable "allowed_features" {
  description = "Allowed features. Valid values: GetObject-Range, GetObject-PartNumber"
  type        = list(string)
  default     = null

  validation {
    condition = var.allowed_features == null ? true : alltrue([
      for feature in var.allowed_features : contains(["GetObject-Range", "GetObject-PartNumber"], feature)
    ])
    error_message = "resource_aws_s3control_object_lambda_access_point, allowed_features must contain only valid values: GetObject-Range, GetObject-PartNumber."
  }
}

variable "cloud_watch_metrics_enabled" {
  description = "Whether or not the CloudWatch metrics configuration is enabled"
  type        = bool
  default     = null
}

variable "supporting_access_point" {
  description = "Standard access point associated with the Object Lambda Access Point"
  type        = string

  validation {
    condition     = length(var.supporting_access_point) > 0
    error_message = "resource_aws_s3control_object_lambda_access_point, supporting_access_point must not be empty."
  }
}

variable "transformation_configurations" {
  description = "List of transformation configurations for the Object Lambda Access Point"
  type = list(object({
    actions = list(string)
    aws_lambda = object({
      function_arn     = string
      function_payload = optional(string)
    })
  }))

  validation {
    condition     = length(var.transformation_configurations) > 0
    error_message = "resource_aws_s3control_object_lambda_access_point, transformation_configurations must contain at least one configuration."
  }

  validation {
    condition = alltrue([
      for config in var.transformation_configurations : alltrue([
        for action in config.actions : contains(["GetObject"], action)
      ])
    ])
    error_message = "resource_aws_s3control_object_lambda_access_point, transformation_configurations actions must contain only valid values: GetObject."
  }

  validation {
    condition = alltrue([
      for config in var.transformation_configurations : length(config.aws_lambda.function_arn) > 0
    ])
    error_message = "resource_aws_s3control_object_lambda_access_point, transformation_configurations aws_lambda function_arn must not be empty."
  }
}