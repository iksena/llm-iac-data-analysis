variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "project_name" {
  description = "The name of the Project."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\-]{1,32}$", var.project_name))
    error_message = "resource_aws_sagemaker_project, project_name must be 1-32 characters long and can only contain alphanumeric characters and hyphens."
  }
}

variable "project_description" {
  description = "A description for the project."
  type        = string
  default     = null
}

variable "service_catalog_provisioning_details" {
  description = "The product ID and provisioning artifact ID to provision a service catalog."
  type = object({
    path_id                  = optional(string)
    product_id               = string
    provisioning_artifact_id = optional(string)
    provisioning_parameters = optional(list(object({
      key   = string
      value = optional(string)
    })))
  })

  validation {
    condition     = var.service_catalog_provisioning_details.product_id != null && var.service_catalog_provisioning_details.product_id != ""
    error_message = "resource_aws_sagemaker_project, service_catalog_provisioning_details.product_id is required and cannot be empty."
  }

  validation {
    condition = var.service_catalog_provisioning_details.provisioning_parameters == null || alltrue([
      for param in var.service_catalog_provisioning_details.provisioning_parameters : param.key != null && param.key != ""
    ])
    error_message = "resource_aws_sagemaker_project, service_catalog_provisioning_details.provisioning_parameters each parameter key is required and cannot be empty."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}