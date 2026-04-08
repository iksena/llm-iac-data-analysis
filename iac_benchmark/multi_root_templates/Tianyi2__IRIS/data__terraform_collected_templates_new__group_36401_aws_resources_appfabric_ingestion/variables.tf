variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "app" {
  description = "Name of the application. Refer to the AWS Documentation for the list of valid values."
  type        = string

  validation {
    condition     = var.app != null && var.app != ""
    error_message = "resource_aws_appfabric_ingestion, app must be specified and cannot be empty."
  }
}

variable "app_bundle_arn" {
  description = "Amazon Resource Name (ARN) of the app bundle to use for the request."
  type        = string

  validation {
    condition     = var.app_bundle_arn != null && var.app_bundle_arn != ""
    error_message = "resource_aws_appfabric_ingestion, app_bundle_arn must be specified and cannot be empty."
  }

  validation {
    condition     = can(regex("^arn:aws:appfabric:", var.app_bundle_arn))
    error_message = "resource_aws_appfabric_ingestion, app_bundle_arn must be a valid AppFabric ARN."
  }
}

variable "ingestion_type" {
  description = "Ingestion type. Valid values are auditLog."
  type        = string

  validation {
    condition     = var.ingestion_type != null && var.ingestion_type != ""
    error_message = "resource_aws_appfabric_ingestion, ingestion_type must be specified and cannot be empty."
  }

  validation {
    condition     = contains(["auditLog"], var.ingestion_type)
    error_message = "resource_aws_appfabric_ingestion, ingestion_type must be one of: auditLog."
  }
}

variable "tenant_id" {
  description = "ID of the application tenant."
  type        = string

  validation {
    condition     = var.tenant_id != null && var.tenant_id != ""
    error_message = "resource_aws_appfabric_ingestion, tenant_id must be specified and cannot be empty."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}