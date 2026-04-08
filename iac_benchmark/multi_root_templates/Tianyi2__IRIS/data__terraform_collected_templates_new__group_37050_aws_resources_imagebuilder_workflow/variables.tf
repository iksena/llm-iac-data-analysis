variable "name" {
  description = "Name of the workflow"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_imagebuilder_workflow, name must not be empty."
  }
}

variable "type" {
  description = "Type of the workflow. Valid values: BUILD, TEST"
  type        = string

  validation {
    condition     = contains(["BUILD", "TEST"], var.type)
    error_message = "resource_aws_imagebuilder_workflow, type must be either BUILD or TEST."
  }
}

variable "workflow_version" {
  description = "Version of the workflow"
  type        = string

  validation {
    condition     = length(var.workflow_version) > 0
    error_message = "resource_aws_imagebuilder_workflow, workflow_version must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "change_description" {
  description = "Change description of the workflow"
  type        = string
  default     = null
}

variable "data" {
  description = "Inline YAML string with data of the workflow. Exactly one of data and uri can be specified"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the workflow"
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "Amazon Resource Name (ARN) of the Key Management Service (KMS) Key used to encrypt the workflow"
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags for the workflow"
  type        = map(string)
  default     = {}
}

variable "uri" {
  description = "S3 URI with data of the workflow. Exactly one of data and uri can be specified"
  type        = string
  default     = null
}