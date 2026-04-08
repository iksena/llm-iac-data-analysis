variable "application_id" {
  description = "The application ID"
  type        = string

  validation {
    condition     = length(var.application_id) > 0
    error_message = "resource_aws_pinpoint_apns_voip_sandbox_channel, application_id must not be empty."
  }
}

variable "enabled" {
  description = "Whether the channel is enabled or disabled"
  type        = bool
  default     = true
}

variable "default_authentication_method" {
  description = "The default authentication method used for APNs"
  type        = string
  default     = null
}

variable "certificate" {
  description = "The pem encoded TLS Certificate from Apple"
  type        = string
  default     = null
  sensitive   = true
}

variable "private_key" {
  description = "The Certificate Private Key file (ie. .key file)"
  type        = string
  default     = null
  sensitive   = true
}

variable "bundle_id" {
  description = "The ID assigned to your iOS app"
  type        = string
  default     = null

  validation {
    condition     = var.bundle_id == null || length(var.bundle_id) > 0
    error_message = "resource_aws_pinpoint_apns_voip_sandbox_channel, bundle_id must not be empty when provided."
  }
}

variable "team_id" {
  description = "The ID assigned to your Apple developer account team"
  type        = string
  default     = null

  validation {
    condition     = var.team_id == null || length(var.team_id) > 0
    error_message = "resource_aws_pinpoint_apns_voip_sandbox_channel, team_id must not be empty when provided."
  }
}

variable "token_key" {
  description = "The .p8 file that you download from your Apple developer account when you create an authentication key"
  type        = string
  default     = null
  sensitive   = true
}

variable "token_key_id" {
  description = "The ID assigned to your signing key"
  type        = string
  default     = null

  validation {
    condition     = var.token_key_id == null || length(var.token_key_id) > 0
    error_message = "resource_aws_pinpoint_apns_voip_sandbox_channel, token_key_id must not be empty when provided."
  }
}