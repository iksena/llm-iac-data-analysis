variable "twilio_account_sid" {
  type        = string
  description = "Twilio Account SID"
}

variable "twilio_api_key" {
  type        = string
  description = "Twilio API Key SID (starts with SK)"
  sensitive   = true
}

variable "twilio_api_secret" {
  type        = string
  description = "Twilio API Secret"
  sensitive   = true
}

variable "twilio_phone_id" {
  type        = string
  description = "Twilio Phone Number ID"
  sensitive   = true
  validation {
    condition     = can(regex("^PN", var.twilio_phone_id))
    error_message = "The twilio_phone_id must start with 'PN'"
  }
}

variable "twilio_trunk_friendly_name" {
  type        = string
  description = "Twilio SIP Trunk Friendly Name"
}

variable "twilio_trunk_domain" {
  type        = string
  description = "Twilio SIP Trunk Domain"
  validation {
    condition     = endswith(var.twilio_trunk_domain, "pstn.twilio.com")
    error_message = "The twilio_trunk_domain must end with 'pstn.twilio.com'"
  }
}

## LiveKit
variable "livekit_sip_url" {
  type        = string
  description = "LiveKit SIP URL"
  validation {
    condition     = can(regex("^sip:[a-z0-9]+\\.sip\\.livekit\\.cloud;transport=tcp$", var.livekit_sip_url))
    error_message = "The livekit_sip_url must be in the format 'sip:xxxxx.sip.livekit.cloud;transport=tcp'"
  }
}

variable "livekit_api_key" {
  type        = string
  description = "LiveKit API Key"
  sensitive   = true
}

variable "livekit_api_secret" {
  type        = string
  description = "LiveKit API Secret"
  sensitive   = true
}

variable "livekit_url" {
  type        = string
  description = "LiveKit Server URL"
  validation {
    condition     = can(regex("^wss://", var.livekit_url))
    error_message = "The livekit_url must start with 'wss://'"
  }
}

variable "livekit_sip_username" {
  type        = string
  description = "LiveKit SIP Username"
  default     = "livekit-sip-user"
}
