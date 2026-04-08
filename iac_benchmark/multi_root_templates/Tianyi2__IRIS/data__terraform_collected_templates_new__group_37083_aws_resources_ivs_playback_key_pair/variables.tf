variable "public_key" {
  description = "Public portion of a customer-generated key pair. Must be an ECDSA public key in PEM format."
  type        = string

  validation {
    condition     = can(regex("-----BEGIN PUBLIC KEY-----", var.public_key))
    error_message = "resource_aws_ivs_playback_key_pair, public_key must be a valid PEM format ECDSA public key starting with '-----BEGIN PUBLIC KEY-----'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Playback Key Pair name."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "timeouts_create" {
  description = "Timeout for create operation."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_ivs_playback_key_pair, timeouts_create must be a valid timeout format (e.g., '5m', '10s', '1h')."
  }
}

variable "timeouts_delete" {
  description = "Timeout for delete operation."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_delete))
    error_message = "resource_aws_ivs_playback_key_pair, timeouts_delete must be a valid timeout format (e.g., '5m', '10s', '1h')."
  }
}