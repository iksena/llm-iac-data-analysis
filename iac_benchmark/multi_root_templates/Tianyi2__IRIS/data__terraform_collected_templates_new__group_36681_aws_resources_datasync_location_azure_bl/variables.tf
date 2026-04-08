variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "access_tier" {
  description = "The access tier that you want your objects or files transferred into. Valid values: HOT, COOL and ARCHIVE. Default: HOT."
  type        = string
  default     = "HOT"

  validation {
    condition     = contains(["HOT", "COOL", "ARCHIVE"], var.access_tier)
    error_message = "resource_aws_datasync_location_azure_blob, access_tier must be one of: HOT, COOL, ARCHIVE."
  }
}

variable "agent_arns" {
  description = "A list of DataSync Agent ARNs with which this location will be associated."
  type        = list(string)

  validation {
    condition     = length(var.agent_arns) > 0
    error_message = "resource_aws_datasync_location_azure_blob, agent_arns must contain at least one ARN."
  }
}

variable "authentication_type" {
  description = "The authentication method DataSync uses to access your Azure Blob Storage. Valid values: SAS."
  type        = string

  validation {
    condition     = contains(["SAS"], var.authentication_type)
    error_message = "resource_aws_datasync_location_azure_blob, authentication_type must be: SAS."
  }
}

variable "blob_type" {
  description = "The type of blob that you want your objects or files to be when transferring them into Azure Blob Storage. Valid values: BLOB. Default: BLOB."
  type        = string
  default     = "BLOB"

  validation {
    condition     = contains(["BLOB"], var.blob_type)
    error_message = "resource_aws_datasync_location_azure_blob, blob_type must be: BLOB."
  }
}

variable "container_url" {
  description = "The URL of the Azure Blob Storage container involved in your transfer."
  type        = string

  validation {
    condition     = length(var.container_url) > 0
    error_message = "resource_aws_datasync_location_azure_blob, container_url cannot be empty."
  }
}

variable "sas_configuration" {
  description = "The SAS configuration that allows DataSync to access your Azure Blob Storage."
  type = object({
    token = string
  })
  default = null

  validation {
    condition     = var.sas_configuration == null || (var.sas_configuration != null && length(var.sas_configuration.token) > 0)
    error_message = "resource_aws_datasync_location_azure_blob, sas_configuration token cannot be empty when sas_configuration is provided."
  }
}

variable "subdirectory" {
  description = "Path segments if you want to limit your transfer to a virtual directory in the container."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value pairs of resource tags to assign to the DataSync Location."
  type        = map(string)
  default     = {}
}