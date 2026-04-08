variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "domain_name" {
  description = "Already-registered domain name to connect the API to."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.domain_name))
    error_message = "resource_aws_api_gateway_base_path_mapping, domain_name must be a valid domain name format."
  }
}

variable "api_id" {
  description = "ID of the API to connect."
  type        = string

  validation {
    condition     = length(var.api_id) > 0
    error_message = "resource_aws_api_gateway_base_path_mapping, api_id cannot be empty."
  }
}

variable "stage_name" {
  description = "Name of a specific deployment stage to expose at the given path. If omitted, callers may select any stage by including its name as a path element after the base path."
  type        = string
  default     = null

  validation {
    condition     = var.stage_name == null || (length(var.stage_name) > 0 && can(regex("^[a-zA-Z0-9_-]+$", var.stage_name)))
    error_message = "resource_aws_api_gateway_base_path_mapping, stage_name must contain only alphanumeric characters, hyphens, and underscores when specified."
  }
}

variable "base_path" {
  description = "Path segment that must be prepended to the path when accessing the API via this mapping. If omitted, the API is exposed at the root of the given domain."
  type        = string
  default     = null

  validation {
    condition     = var.base_path == null || can(regex("^[a-zA-Z0-9/_-]*$", var.base_path))
    error_message = "resource_aws_api_gateway_base_path_mapping, base_path must contain only alphanumeric characters, hyphens, underscores, and forward slashes when specified."
  }
}

variable "domain_name_id" {
  description = "The identifier for the domain name resource. Supported only for private custom domain names."
  type        = string
  default     = null

  validation {
    condition     = var.domain_name_id == null || length(var.domain_name_id) > 0
    error_message = "resource_aws_api_gateway_base_path_mapping, domain_name_id cannot be empty when specified."
  }
}