variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "model_package_group_name" {
  description = "The name of the model group."
  type        = string

  validation {
    condition     = length(var.model_package_group_name) > 0
    error_message = "resource_aws_sagemaker_model_package_group, model_package_group_name must not be empty."
  }
}

variable "model_package_group_description" {
  description = "A description for the model group."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}