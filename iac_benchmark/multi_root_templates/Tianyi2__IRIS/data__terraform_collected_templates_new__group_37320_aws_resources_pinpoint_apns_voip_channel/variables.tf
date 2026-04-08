variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "application_id" {
  description = "The application ID."
  type        = string

  validation {
    condition     = var.application_id != null && var.application_id != ""
    error_message = "resource_aws_pinpoint_apns_voip_channel, application_id is required and cannot be empty."
  }
}

variable "enabled" {
  description = "Whether the channel is enabled or disabled. Defaults to true."
  type        = bool
  default     = true
}

variable "default_authentication_method" {
  description = "The default authentication method used for APNs. NOTE: Amazon Pinpoint uses this default for every APNs push notification that you send using the console."
  type        = string
  default     = null
}

variable "certificate" {
  description = "The pem encoded TLS Certificate from Apple. Required if using Certificate credentials."
  type        = string
  default     = null
  sensitive   = true
}

variable "private_key" {
  description = "The Certificate Private Key file (ie. .key file). Required if using Certificate credentials."
  type        = string
  default     = null
  sensitive   = true
}

variable "bundle_id" {
  description = "The ID assigned to your iOS app. Required if using Key credentials."
  type        = string
  default     = null
}

variable "team_id" {
  description = "The ID assigned to your Apple developer account team. Required if using Key credentials."
  type        = string
  default     = null
}

variable "token_key" {
  description = "The .p8 file that you download from your Apple developer account when you create an authentication key. Required if using Key credentials."
  type        = string
  default     = null
  sensitive   = true
}

variable "token_key_id" {
  description = "The ID assigned to your signing key. Required if using Key credentials."
  type        = string
  default     = null
}