variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_ivs_stream_key, region must be a valid AWS region format or null."
  }
}

variable "channel_arn" {
  type        = string
  description = "ARN of the Channel."

  validation {
    condition     = can(regex("^arn:aws:ivs:[a-z0-9-]+:[0-9]+:channel/.+", var.channel_arn))
    error_message = "data_aws_ivs_stream_key, channel_arn must be a valid IVS channel ARN format."
  }
}