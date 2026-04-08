variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "as2_id" {
  description = "The As2Id is the AS2 name as defined in the RFC 4130. For inbound transfers this is the AS2 From Header for the AS2 messages sent from the partner. For Outbound messages this is the AS2 To Header for the AS2 messages sent to the partner. This ID cannot include spaces."
  type        = string

  validation {
    condition     = can(regex("^[^\\s]+$", var.as2_id))
    error_message = "resource_aws_transfer_profile, as2_id cannot include spaces."
  }
}

variable "certificate_ids" {
  description = "The list of certificate Ids from the imported certificate operation"
  type        = list(string)
  default     = null
}

variable "profile_type" {
  description = "The profile type should be LOCAL or PARTNER"
  type        = string

  validation {
    condition     = contains(["LOCAL", "PARTNER"], var.profile_type)
    error_message = "resource_aws_transfer_profile, profile_type must be either LOCAL or PARTNER."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}