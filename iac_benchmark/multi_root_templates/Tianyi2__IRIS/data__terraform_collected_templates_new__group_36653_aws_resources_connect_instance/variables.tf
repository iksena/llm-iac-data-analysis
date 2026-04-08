variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "auto_resolve_best_voices_enabled" {
  description = "Specifies whether auto resolve best voices is enabled."
  type        = bool
  default     = true
}

variable "contact_flow_logs_enabled" {
  description = "Specifies whether contact flow logs are enabled."
  type        = bool
  default     = false
}

variable "contact_lens_enabled" {
  description = "Specifies whether contact lens is enabled."
  type        = bool
  default     = true
}

variable "directory_id" {
  description = "The identifier for the directory if identity_management_type is EXISTING_DIRECTORY."
  type        = string
  default     = null
}

variable "early_media_enabled" {
  description = "Specifies whether early media for outbound calls is enabled. Defaults to true if outbound calls is enabled."
  type        = bool
  default     = null
}

variable "identity_management_type" {
  description = "Specifies the identity management type attached to the instance."
  type        = string

  validation {
    condition     = contains(["SAML", "CONNECT_MANAGED", "EXISTING_DIRECTORY"], var.identity_management_type)
    error_message = "resource_aws_connect_instance, identity_management_type must be one of: SAML, CONNECT_MANAGED, EXISTING_DIRECTORY."
  }
}

variable "inbound_calls_enabled" {
  description = "Specifies whether inbound calls are enabled."
  type        = bool
}

variable "instance_alias" {
  description = "Specifies the name of the instance. Required if directory_id not specified."
  type        = string
  default     = null
}

variable "multi_party_conference_enabled" {
  description = "Specifies whether multi-party calls/conference is enabled."
  type        = bool
  default     = false
}

variable "outbound_calls_enabled" {
  description = "Specifies whether outbound calls are enabled."
  type        = bool
}

variable "tags" {
  description = "Tags to apply to the Instance."
  type        = map(string)
  default     = {}
}