variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "sink_identifier" {
  description = "ARN of the sink."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:oam:", var.sink_identifier))
    error_message = "data_aws_oam_sink, sink_identifier must be a valid OAM sink ARN starting with 'arn:aws:oam:'."
  }
}