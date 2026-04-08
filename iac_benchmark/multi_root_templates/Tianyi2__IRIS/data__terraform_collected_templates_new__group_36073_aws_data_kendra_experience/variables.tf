variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "experience_id" {
  type        = string
  description = "Identifier of the Experience."

  validation {
    condition     = can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.experience_id))
    error_message = "data_aws_kendra_experience, experience_id must be a valid UUID format."
  }
}

variable "index_id" {
  type        = string
  description = "Identifier of the index that contains the Experience."

  validation {
    condition     = can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.index_id))
    error_message = "data_aws_kendra_experience, index_id must be a valid UUID format."
  }
}