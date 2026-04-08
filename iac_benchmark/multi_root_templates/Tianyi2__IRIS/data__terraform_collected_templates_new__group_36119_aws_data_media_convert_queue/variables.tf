variable "id" {
  description = "Unique identifier of the queue. The same as name."
  type        = string

  validation {
    condition     = length(var.id) > 0
    error_message = "data_aws_media_convert_queue, id must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || length(var.region) > 0
    error_message = "data_aws_media_convert_queue, region must be a non-empty string when specified."
  }
}