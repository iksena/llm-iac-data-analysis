variable "activate" {
  description = "Specifies whether GuardDuty is to start using the uploaded ThreatIntelSet"
  type        = bool

  validation {
    condition     = can(tobool(var.activate))
    error_message = "resource_aws_guardduty_threatintelset, activate must be a boolean value."
  }
}

variable "detector_id" {
  description = "The detector ID of the GuardDuty"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{32}$", var.detector_id))
    error_message = "resource_aws_guardduty_threatintelset, detector_id must be a valid GuardDuty detector ID (32 character hex string)."
  }
}

variable "format" {
  description = "The format of the file that contains the ThreatIntelSet"
  type        = string

  validation {
    condition = contains([
      "TXT",
      "STIX",
      "OTX_CSV",
      "ALIEN_VAULT",
      "PROOF_POINT",
      "FIRE_EYE"
    ], var.format)
    error_message = "resource_aws_guardduty_threatintelset, format must be one of: TXT, STIX, OTX_CSV, ALIEN_VAULT, PROOF_POINT, FIRE_EYE."
  }
}

variable "location" {
  description = "The URI of the file that contains the ThreatIntelSet"
  type        = string

  validation {
    condition     = can(regex("^https?://", var.location))
    error_message = "resource_aws_guardduty_threatintelset, location must be a valid HTTP or HTTPS URI."
  }
}

variable "name" {
  description = "The friendly name to identify the ThreatIntelSet"
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 300
    error_message = "resource_aws_guardduty_threatintelset, name must be between 1 and 300 characters."
  }
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}

  validation {
    condition     = can(keys(var.tags))
    error_message = "resource_aws_guardduty_threatintelset, tags must be a valid map of strings."
  }
}

variable "timeouts" {
  description = "Timeouts for create and delete operations"
  type = object({
    create = optional(string)
    delete = optional(string)
  })
  default = null

  validation {
    condition = var.timeouts == null || (
      (var.timeouts.create == null || can(regex("^[0-9]+[smh]$", var.timeouts.create))) &&
      (var.timeouts.delete == null || can(regex("^[0-9]+[smh]$", var.timeouts.delete)))
    )
    error_message = "resource_aws_guardduty_threatintelset, timeouts create and delete must be valid duration strings (e.g., '5m', '1h')."
  }
}