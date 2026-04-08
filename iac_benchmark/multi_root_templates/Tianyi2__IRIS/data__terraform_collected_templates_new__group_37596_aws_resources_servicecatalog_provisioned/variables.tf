variable "name" {
  description = "User-friendly name of the provisioned product."
  type        = string
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "accept_language" {
  description = "Language code. Valid values: en (English), jp (Japanese), zh (Chinese). Default value is en."
  type        = string
  default     = "en"

  validation {
    condition     = contains(["en", "jp", "zh"], var.accept_language)
    error_message = "resource_aws_servicecatalog_provisioned_product, accept_language must be one of: en, jp, zh."
  }
}

variable "ignore_errors" {
  description = "Only applies to deleting. If set to true, AWS Service Catalog stops managing the specified provisioned product even if it cannot delete the underlying resources. The default value is false."
  type        = bool
  default     = false
}

variable "notification_arns" {
  description = "Passed to CloudFormation. The SNS topic ARNs to which to publish stack-related events."
  type        = list(string)
  default     = null
}

variable "path_id" {
  description = "Path identifier of the product. This value is optional if the product has a default path, and required if the product has more than one path. You must provide path_id or path_name, but not both."
  type        = string
  default     = null
}

variable "path_name" {
  description = "Name of the path. You must provide path_id or path_name, but not both."
  type        = string
  default     = null
}

variable "product_id" {
  description = "Product identifier. For example, prod-abcdzk7xy33qa. You must provide product_id or product_name, but not both."
  type        = string
  default     = null
}

variable "product_name" {
  description = "Name of the product. You must provide product_id or product_name, but not both."
  type        = string
  default     = null
}

variable "provisioning_artifact_id" {
  description = "Identifier of the provisioning artifact. For example, pa-4abcdjnxjj6ne. You must provide the provisioning_artifact_id or provisioning_artifact_name, but not both."
  type        = string
  default     = null
}

variable "provisioning_artifact_name" {
  description = "Name of the provisioning artifact. You must provide the provisioning_artifact_id or provisioning_artifact_name, but not both."
  type        = string
  default     = null
}

variable "provisioning_parameters" {
  description = "Configuration block with parameters specified by the administrator that are required for provisioning the product."
  type = list(object({
    key                = string
    use_previous_value = optional(bool)
    value              = optional(string)
  }))
  default = []
}

variable "retain_physical_resources" {
  description = "Only applies to deleting. Whether to delete the Service Catalog provisioned product but leave the CloudFormation stack, stack set, or the underlying resources of the deleted provisioned product. The default value is false."
  type        = bool
  default     = false
}

variable "stack_set_provisioning_preferences" {
  description = "Configuration block with information about the provisioning preferences for a stack set."
  type = object({
    accounts                     = optional(list(string))
    failure_tolerance_count      = optional(number)
    failure_tolerance_percentage = optional(number)
    max_concurrency_count        = optional(number)
    max_concurrency_percentage   = optional(number)
    regions                      = optional(list(string))
  })
  default = null

  validation {
    condition = var.stack_set_provisioning_preferences == null || (
      (var.stack_set_provisioning_preferences.failure_tolerance_count == null || var.stack_set_provisioning_preferences.failure_tolerance_percentage == null) &&
      !(var.stack_set_provisioning_preferences.failure_tolerance_count != null && var.stack_set_provisioning_preferences.failure_tolerance_percentage != null)
    )
    error_message = "resource_aws_servicecatalog_provisioned_product, failure_tolerance_count and failure_tolerance_percentage are mutually exclusive in stack_set_provisioning_preferences. You must specify either failure_tolerance_count or failure_tolerance_percentage, but not both."
  }

  validation {
    condition = var.stack_set_provisioning_preferences == null || (
      (var.stack_set_provisioning_preferences.max_concurrency_count == null || var.stack_set_provisioning_preferences.max_concurrency_percentage == null) &&
      !(var.stack_set_provisioning_preferences.max_concurrency_count != null && var.stack_set_provisioning_preferences.max_concurrency_percentage != null)
    )
    error_message = "resource_aws_servicecatalog_provisioned_product, max_concurrency_count and max_concurrency_percentage are mutually exclusive in stack_set_provisioning_preferences. You must specify either max_concurrency_count or max_concurrency_percentage, but not both."
  }
}

variable "tags" {
  description = "Tags to apply to the provisioned product. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}