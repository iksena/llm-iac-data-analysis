variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "A unique identifier describing the queue"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_media_convert_queue, name must not be empty."
  }
}

variable "concurrent_jobs" {
  description = "The maximum number of jobs your queue can process concurrently. For on-demand queues, the value you enter is constrained by your service quotas for Maximum concurrent jobs, per on-demand queue and Maximum concurrent jobs, per account. For reserved queues, specify the number of jobs you can process concurrently in your reservation plan instead."
  type        = number
  default     = null

  validation {
    condition     = var.concurrent_jobs == null || var.concurrent_jobs > 0
    error_message = "resource_aws_media_convert_queue, concurrent_jobs must be greater than 0 when specified."
  }
}

variable "description" {
  description = "A description of the queue"
  type        = string
  default     = null
}

variable "pricing_plan" {
  description = "Specifies whether the pricing plan for the queue is on-demand or reserved. Valid values are ON_DEMAND or RESERVED. Default to ON_DEMAND."
  type        = string
  default     = "ON_DEMAND"

  validation {
    condition     = contains(["ON_DEMAND", "RESERVED"], var.pricing_plan)
    error_message = "resource_aws_media_convert_queue, pricing_plan must be either ON_DEMAND or RESERVED."
  }
}

variable "reservation_plan_settings" {
  description = "A detail pricing plan of the reserved queue"
  type = object({
    commitment     = string
    renewal_type   = string
    reserved_slots = number
  })
  default = null

  validation {
    condition = var.reservation_plan_settings == null || (
      var.reservation_plan_settings.commitment == "ONE_YEAR" &&
      contains(["AUTO_RENEW", "EXPIRE"], var.reservation_plan_settings.renewal_type) &&
      var.reservation_plan_settings.reserved_slots > 0
    )
    error_message = "resource_aws_media_convert_queue, reservation_plan_settings commitment must be ONE_YEAR, renewal_type must be AUTO_RENEW or EXPIRE, and reserved_slots must be greater than 0."
  }
}

variable "status" {
  description = "A status of the queue. Valid values are ACTIVE or RESERVED. Default to PAUSED."
  type        = string
  default     = "PAUSED"

  validation {
    condition     = contains(["ACTIVE", "RESERVED", "PAUSED"], var.status)
    error_message = "resource_aws_media_convert_queue, status must be ACTIVE, RESERVED, or PAUSED."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}