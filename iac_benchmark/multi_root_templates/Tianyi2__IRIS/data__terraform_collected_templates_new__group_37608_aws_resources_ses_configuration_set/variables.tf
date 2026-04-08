variable "name" {
  description = "Name of the configuration set."
  type        = string
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "delivery_options" {
  description = "Whether messages that use the configuration set are required to use TLS."
  type = object({
    tls_policy = optional(string)
  })
  default = null

  validation {
    condition     = var.delivery_options == null || var.delivery_options.tls_policy == null || contains(["Require", "Optional"], var.delivery_options.tls_policy)
    error_message = "resource_aws_ses_configuration_set, delivery_options.tls_policy must be either 'Require' or 'Optional'."
  }
}

variable "reputation_metrics_enabled" {
  description = "Whether or not Amazon SES publishes reputation metrics for the configuration set, such as bounce and complaint rates, to Amazon CloudWatch. The default value is false."
  type        = bool
  default     = false
}

variable "sending_enabled" {
  description = "Whether email sending is enabled or disabled for the configuration set. The default value is true."
  type        = bool
  default     = true
}

variable "tracking_options" {
  description = "Domain that is used to redirect email recipients to an Amazon SES-operated domain."
  type = object({
    custom_redirect_domain = optional(string)
  })
  default = null
}