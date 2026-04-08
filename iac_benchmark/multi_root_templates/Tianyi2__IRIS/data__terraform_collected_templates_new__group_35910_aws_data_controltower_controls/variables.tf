variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "target_identifier" {
  description = "The ARN of the organizational unit."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:organizations::[0-9]+:ou/o-[a-z0-9]+/ou-[a-z0-9]+$", var.target_identifier))
    error_message = "data_aws_controltower_controls, target_identifier must be a valid organizational unit ARN."
  }
}