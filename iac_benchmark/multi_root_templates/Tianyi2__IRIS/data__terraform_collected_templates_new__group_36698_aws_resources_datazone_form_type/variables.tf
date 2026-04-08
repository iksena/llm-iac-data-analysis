variable "domain_identifier" {
  description = "Identifier of the domain"
  type        = string
}

variable "name" {
  description = "Name of the form type. Must be the name of the structure in smithy document"
  type        = string
}

variable "owning_project_identifier" {
  description = "Identifier of project that owns the form type"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]{1,36}$", var.owning_project_identifier))
    error_message = "resource_aws_datazone_form_type, owning_project_identifier must follow regex of ^[a-zA-Z0-9_-]{1,36}$."
  }
}

variable "model_smithy" {
  description = "Smithy document that indicates the model of the API"
  type        = string
  validation {
    condition     = length(var.model_smithy) >= 1 && length(var.model_smithy) <= 100000
    error_message = "resource_aws_datazone_form_type, model_smithy must be between 1 and 100,000 characters and be encoded as a smithy document."
  }
}

variable "description" {
  description = "Description of form type"
  type        = string
  default     = null
  validation {
    condition = var.description == null || (
      length(var.description) >= 1 && length(var.description) <= 2048
    )
    error_message = "resource_aws_datazone_form_type, description must have a length of between 1 and 2048 characters."
  }
}

variable "status" {
  description = "Status of form type. Must be \"ENABLED\" or \"DISABLED\". If status is set to \"ENABLED\" terraform cannot delete the resource until it is manually changed in the AWS console"
  type        = string
  default     = null
  validation {
    condition     = var.status == null || contains(["ENABLED", "DISABLED"], var.status)
    error_message = "resource_aws_datazone_form_type, status must be \"ENABLED\" or \"DISABLED\"."
  }
}