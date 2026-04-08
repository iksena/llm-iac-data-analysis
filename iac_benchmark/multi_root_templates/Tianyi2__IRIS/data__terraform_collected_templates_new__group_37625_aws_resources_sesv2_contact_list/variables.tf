variable "contact_list_name" {
  description = "Name of the contact list"
  type        = string
  validation {
    condition     = length(var.contact_list_name) > 0
    error_message = "resource_aws_sesv2_contact_list, contact_list_name must not be empty."
  }
}

variable "description" {
  description = "Description of what the contact list is about"
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags for the contact list"
  type        = map(string)
  default     = {}
}

variable "topics" {
  description = "Configuration blocks with topic for the contact list"
  type = list(object({
    default_subscription_status = string
    display_name                = string
    topic_name                  = string
    description                 = optional(string)
    region                      = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for topic in var.topics :
      contains(["OPT_IN", "OPT_OUT"], topic.default_subscription_status)
    ])
    error_message = "resource_aws_sesv2_contact_list, topics default_subscription_status must be either 'OPT_IN' or 'OPT_OUT'."
  }

  validation {
    condition = alltrue([
      for topic in var.topics :
      length(topic.display_name) > 0
    ])
    error_message = "resource_aws_sesv2_contact_list, topics display_name must not be empty."
  }

  validation {
    condition = alltrue([
      for topic in var.topics :
      length(topic.topic_name) > 0
    ])
    error_message = "resource_aws_sesv2_contact_list, topics topic_name must not be empty."
  }
}