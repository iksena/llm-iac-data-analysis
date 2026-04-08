variable "contact_id" {
  description = "The Amazon Resource Name (ARN) of the contact or escalation plan"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:ssm-contacts:[a-z0-9-]+:[0-9]{12}:contact/[a-zA-Z0-9_-]+$", var.contact_id))
    error_message = "data_ssmcontacts_plan, contact_id must be a valid SSM Contacts ARN in the format 'arn:aws:ssm-contacts:region:account-id:contact/contact-name'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_ssmcontacts_plan, region must be a valid AWS region name or null."
  }
}