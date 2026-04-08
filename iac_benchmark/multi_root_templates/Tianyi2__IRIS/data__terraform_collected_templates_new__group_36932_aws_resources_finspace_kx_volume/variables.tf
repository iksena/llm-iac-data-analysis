variable "name" {
  type        = string
  description = "Unique name for the volume that you want to create."

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_finspace_kx_volume, name must be a non-empty string."
  }
}

variable "environment_id" {
  type        = string
  description = "A unique identifier for the kdb environment, whose clusters can attach to the volume."

  validation {
    condition     = length(var.environment_id) > 0
    error_message = "resource_aws_finspace_kx_volume, environment_id must be a non-empty string."
  }
}

variable "availability_zones" {
  type        = list(string)
  description = "The identifier of the AWS Availability Zone IDs."

  validation {
    condition     = length(var.availability_zones) > 0
    error_message = "resource_aws_finspace_kx_volume, availability_zones must contain at least one availability zone."
  }
}

variable "az_mode" {
  type        = string
  description = "The number of availability zones you want to assign per volume. Currently, Finspace only support SINGLE for volumes."

  validation {
    condition     = var.az_mode == "SINGLE"
    error_message = "resource_aws_finspace_kx_volume, az_mode must be 'SINGLE'."
  }
}

variable "type" {
  type        = string
  description = "The type of file system volume. Currently, FinSpace only supports the NAS_1 volume type."

  validation {
    condition     = var.type == "NAS_1"
    error_message = "resource_aws_finspace_kx_volume, type must be 'NAS_1'."
  }
}

variable "description" {
  type        = string
  description = "Description of the volume."
  default     = null
}

variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A list of key-value pairs to label the volume. You can add up to 50 tags to a volume."
  default     = {}

  validation {
    condition     = length(var.tags) <= 50
    error_message = "resource_aws_finspace_kx_volume, tags cannot contain more than 50 key-value pairs."
  }
}

variable "nas1_configuration" {
  type = object({
    size = number
    type = string
  })
  description = "Specifies the configuration for the Network attached storage (NAS_1) file system volume. This parameter is required when volume_type is NAS_1."
  default     = null

  validation {
    condition = var.nas1_configuration == null || (
      var.nas1_configuration.size != null &&
      var.nas1_configuration.type != null &&
      var.nas1_configuration.size > 0 &&
      length(var.nas1_configuration.type) > 0
    )
    error_message = "resource_aws_finspace_kx_volume, nas1_configuration when provided must have valid size (> 0) and type (non-empty string)."
  }
}

variable "timeouts" {
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "45m")
  })
  description = "Configuration options for resource operation timeouts."
  default = {
    create = "30m"
    update = "30m"
    delete = "45m"
  }
}