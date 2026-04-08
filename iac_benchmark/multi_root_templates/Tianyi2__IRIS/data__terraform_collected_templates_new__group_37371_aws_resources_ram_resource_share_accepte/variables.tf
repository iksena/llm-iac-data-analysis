variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "share_arn" {
  description = "The ARN of the resource share."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:ram:[a-z0-9-]+:[0-9]{12}:resource-share/[a-f0-9-]+$", var.share_arn))
    error_message = "resource_aws_ram_resource_share_accepter, share_arn must be a valid AWS RAM resource share ARN."
  }
}