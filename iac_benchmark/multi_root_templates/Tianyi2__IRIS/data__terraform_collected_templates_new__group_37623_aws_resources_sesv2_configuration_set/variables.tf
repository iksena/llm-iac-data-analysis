variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "configuration_set_name" {
  description = "The name of the configuration set."
  type        = string

  validation {
    condition     = length(var.configuration_set_name) > 0
    error_message = "resource_aws_sesv2_configuration_set, configuration_set_name must not be empty."
  }
}

variable "delivery_options" {
  description = "An object that defines the dedicated IP pool that is used to send emails that you send using the configuration set."
  type = object({
    max_delivery_seconds = optional(number)
    sending_pool_name    = optional(string)
    tls_policy           = optional(string)
  })
  default = null

  validation {
    condition = var.delivery_options == null || (
      var.delivery_options.max_delivery_seconds == null ||
      (var.delivery_options.max_delivery_seconds >= 300 && var.delivery_options.max_delivery_seconds <= 50400)
    )
    error_message = "resource_aws_sesv2_configuration_set, max_delivery_seconds must be between 300 and 50400 seconds."
  }

  validation {
    condition = var.delivery_options == null || (
      var.delivery_options.tls_policy == null ||
      contains(["REQUIRE", "OPTIONAL"], var.delivery_options.tls_policy)
    )
    error_message = "resource_aws_sesv2_configuration_set, tls_policy must be either 'REQUIRE' or 'OPTIONAL'."
  }
}

variable "reputation_options" {
  description = "An object that defines whether or not Amazon SES collects reputation metrics for the emails that you send that use the configuration set."
  type = object({
    reputation_metrics_enabled = optional(bool)
  })
  default = null
}

variable "sending_options" {
  description = "An object that defines whether or not Amazon SES can send email that you send using the configuration set."
  type = object({
    sending_enabled = optional(bool)
  })
  default = null
}

variable "suppression_options" {
  description = "An object that contains information about the suppression list preferences for your account."
  type = object({
    suppressed_reasons = optional(list(string))
  })
  default = null

  validation {
    condition = var.suppression_options == null || (
      var.suppression_options.suppressed_reasons == null ||
      length(setsubtract(var.suppression_options.suppressed_reasons, ["BOUNCE", "COMPLAINT"])) == 0
    )
    error_message = "resource_aws_sesv2_configuration_set, suppressed_reasons must only contain 'BOUNCE' or 'COMPLAINT'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the service."
  type        = map(string)
  default     = {}
}

variable "tracking_options" {
  description = "An object that defines the open and click tracking options for emails that you send using the configuration set."
  type = object({
    custom_redirect_domain = string
    https_policy           = optional(string)
  })
  default = null

  validation {
    condition = var.tracking_options == null || (
      var.tracking_options.https_policy == null ||
      contains(["REQUIRE", "REQUIRE_OPEN_ONLY", "OPTIONAL"], var.tracking_options.https_policy)
    )
    error_message = "resource_aws_sesv2_configuration_set, https_policy must be 'REQUIRE', 'REQUIRE_OPEN_ONLY', or 'OPTIONAL'."
  }

  validation {
    condition = var.tracking_options == null || (
      length(var.tracking_options.custom_redirect_domain) > 0
    )
    error_message = "resource_aws_sesv2_configuration_set, custom_redirect_domain must not be empty when tracking_options is specified."
  }
}

variable "vdm_options" {
  description = "An object that defines the VDM settings that apply to emails that you send using the configuration set."
  type = object({
    dashboard_options = optional(object({
      engagement_metrics = optional(string)
    }))
    guardian_options = optional(object({
      optimized_shared_delivery = optional(string)
    }))
  })
  default = null

  validation {
    condition = var.vdm_options == null || (
      var.vdm_options.dashboard_options == null ||
      var.vdm_options.dashboard_options.engagement_metrics == null ||
      contains(["ENABLED", "DISABLED"], var.vdm_options.dashboard_options.engagement_metrics)
    )
    error_message = "resource_aws_sesv2_configuration_set, engagement_metrics must be 'ENABLED' or 'DISABLED'."
  }

  validation {
    condition = var.vdm_options == null || (
      var.vdm_options.guardian_options == null ||
      var.vdm_options.guardian_options.optimized_shared_delivery == null ||
      contains(["ENABLED", "DISABLED"], var.vdm_options.guardian_options.optimized_shared_delivery)
    )
    error_message = "resource_aws_sesv2_configuration_set, optimized_shared_delivery must be 'ENABLED' or 'DISABLED'."
  }
}