variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "arn" {
  description = "ARN of the firewall."
  type        = string
  default     = null
}

variable "name" {
  description = "Descriptive name of the firewall."
  type        = string
  default     = null
}