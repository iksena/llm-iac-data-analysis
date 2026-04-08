variable "enabled" {
  description = "Boolean value indicating if Proactive Engagement should be enabled or not"
  type        = bool

  validation {
    condition     = can(var.enabled)
    error_message = "resource_aws_shield_proactive_engagement, enabled must be a boolean value."
  }
}

variable "emergency_contact" {
  description = "One or more emergency contacts. You must provide at least one phone number in the emergency contact list"
  type = list(object({
    contact_notes = optional(string)
    email_address = string
    phone_number  = optional(string)
  }))

  validation {
    condition     = length(var.emergency_contact) > 0
    error_message = "resource_aws_shield_proactive_engagement, emergency_contact must contain at least one contact."
  }

  validation {
    condition = alltrue([
      for contact in var.emergency_contact :
      can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", contact.email_address))
    ])
    error_message = "resource_aws_shield_proactive_engagement, emergency_contact email_address must be a valid email format."
  }

  validation {
    condition = alltrue([
      for contact in var.emergency_contact :
      contact.phone_number == null || can(regex("^\\+[1-9]\\d{0,14}$", contact.phone_number))
    ])
    error_message = "resource_aws_shield_proactive_engagement, emergency_contact phone_number must start with + and be up to 15 digits."
  }

  validation {
    condition = anytrue([
      for contact in var.emergency_contact :
      contact.phone_number != null && contact.phone_number != ""
    ])
    error_message = "resource_aws_shield_proactive_engagement, emergency_contact must include at least one phone number to enable proactive engagement."
  }
}