variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "repository_name" {
  description = "Name of the repository."
  type        = string

  validation {
    condition     = var.repository_name != null && var.repository_name != ""
    error_message = "resource_aws_ecrpublic_repository, repository_name: repository_name is required and cannot be empty."
  }
}

variable "catalog_data" {
  description = "Catalog data configuration for the repository."
  type = object({
    about_text        = optional(string)
    architectures     = optional(list(string))
    description       = optional(string)
    logo_image_blob   = optional(string)
    operating_systems = optional(list(string))
    usage_text        = optional(string)
  })
  default = null

  validation {
    condition = var.catalog_data == null || (
      var.catalog_data.architectures == null ||
      alltrue([for arch in var.catalog_data.architectures : contains(["ARM", "ARM 64", "x86", "x86-64"], arch)])
    )
    error_message = "resource_aws_ecrpublic_repository, architectures: Valid architectures are: ARM, ARM 64, x86, x86-64."
  }

  validation {
    condition = var.catalog_data == null || (
      var.catalog_data.operating_systems == null ||
      alltrue([for os in var.catalog_data.operating_systems : contains(["Linux", "Windows"], os)])
    )
    error_message = "resource_aws_ecrpublic_repository, operating_systems: Valid operating systems are: Linux, Windows."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "delete_timeout" {
  description = "Delete timeout configuration"
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.delete_timeout))
    error_message = "resource_aws_ecrpublic_repository, delete_timeout: timeout must be a valid duration (e.g., '20m', '1h', '30s')."
  }
}