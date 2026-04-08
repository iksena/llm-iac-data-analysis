variable "name" {
  description = "Unique name for your CloudFront KeyValueStore"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_cloudfront_key_value_store, name must not be empty."
  }
}

variable "comment" {
  description = "Comment"
  type        = string
  default     = null
}

variable "timeouts_create" {
  description = "Timeout for create operation"
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_cloudfront_key_value_store, timeouts_create must be a valid duration (e.g., 30m, 1h, 300s)."
  }
}