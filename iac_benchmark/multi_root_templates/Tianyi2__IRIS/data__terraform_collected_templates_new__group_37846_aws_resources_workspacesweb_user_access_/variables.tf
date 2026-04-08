variable "kinesis_stream_arn" {
  description = "ARN of the Kinesis stream"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kinesis:", var.kinesis_stream_arn))
    error_message = "resource_aws_workspacesweb_user_access_logging_settings, kinesis_stream_arn must be a valid Kinesis stream ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_workspacesweb_user_access_logging_settings, region must be a valid AWS region format (e.g., us-west-2)."
  }
}

variable "tags" {
  description = "Map of tags assigned to the resource"
  type        = map(string)
  default     = {}

  validation {
    condition     = can(var.tags) && alltrue([for k, v in var.tags : can(tostring(k)) && can(tostring(v))])
    error_message = "resource_aws_workspacesweb_user_access_logging_settings, tags must be a map of strings."
  }
}