variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_oam_link, region must be a valid AWS region identifier or null."
  }
}

variable "link_identifier" {
  description = "ARN of the link."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:oam:[a-z0-9-]+:[0-9]{12}:link/[a-z0-9-]+$", var.link_identifier))
    error_message = "data_aws_oam_link, link_identifier must be a valid OAM link ARN."
  }
}