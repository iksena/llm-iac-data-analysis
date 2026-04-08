variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "activate" {
  description = "Specifies whether GuardDuty is to start using the uploaded IPSet."
  type        = bool

  validation {
    condition     = can(var.activate)
    error_message = "resource_aws_guardduty_ipset, activate must be a boolean value."
  }
}

variable "detector_id" {
  description = "The detector ID of the GuardDuty."
  type        = string

  validation {
    condition     = length(var.detector_id) > 0
    error_message = "resource_aws_guardduty_ipset, detector_id cannot be empty."
  }
}

variable "format" {
  description = "The format of the file that contains the IPSet. Valid values: TXT | STIX | OTX_CSV | ALIEN_VAULT | PROOF_POINT | FIRE_EYE"
  type        = string

  validation {
    condition     = contains(["TXT", "STIX", "OTX_CSV", "ALIEN_VAULT", "PROOF_POINT", "FIRE_EYE"], var.format)
    error_message = "resource_aws_guardduty_ipset, format must be one of: TXT, STIX, OTX_CSV, ALIEN_VAULT, PROOF_POINT, FIRE_EYE."
  }
}

variable "location" {
  description = "The URI of the file that contains the IPSet."
  type        = string

  validation {
    condition     = length(var.location) > 0
    error_message = "resource_aws_guardduty_ipset, location cannot be empty."
  }

  validation {
    condition     = can(regex("^https?://", var.location))
    error_message = "resource_aws_guardduty_ipset, location must be a valid URI starting with http:// or https://."
  }
}

variable "name" {
  description = "The friendly name to identify the IPSet."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_guardduty_ipset, name cannot be empty."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = null
}