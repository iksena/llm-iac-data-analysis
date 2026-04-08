variable "name" {
  description = "A unique identifier for the dataview"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_finspace_kx_dataview, name must not be empty."
  }
}

variable "environment_id" {
  description = "Unique identifier for the KX environment"
  type        = string

  validation {
    condition     = length(var.environment_id) > 0
    error_message = "resource_aws_finspace_kx_dataview, environment_id must not be empty."
  }
}

variable "database_name" {
  description = "The name of the database where you want to create a dataview"
  type        = string

  validation {
    condition     = length(var.database_name) > 0
    error_message = "resource_aws_finspace_kx_dataview, database_name must not be empty."
  }
}

variable "az_mode" {
  description = "The number of availability zones you want to assign per cluster. This can be one of the following: SINGLE - Assigns one availability zone per cluster. MULTI - Assigns all the availability zones per cluster"
  type        = string

  validation {
    condition     = contains(["SINGLE", "MULTI"], var.az_mode)
    error_message = "resource_aws_finspace_kx_dataview, az_mode must be either 'SINGLE' or 'MULTI'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "auto_update" {
  description = "The option to specify whether you want to apply all the future additions and corrections automatically to the dataview, when you ingest new changesets. The default value is false"
  type        = bool
  default     = false
}

variable "availability_zone_id" {
  description = "The identifier of the availability zones. If attaching a volume, the volume must be in the same availability zone as the dataview that you are attaching to"
  type        = string
  default     = null
}

variable "changeset_id" {
  description = "A unique identifier of the changeset of the database that you want to use to ingest data"
  type        = string
  default     = null
}

variable "description" {
  description = "A description for the dataview"
  type        = string
  default     = null
}

variable "read_write" {
  description = "The option to specify whether you want to make the dataview writable to perform database maintenance"
  type        = bool
  default     = null

  validation {
    condition = var.read_write == null ? true : (
      var.read_write == true ? var.auto_update == false : true
    )
    error_message = "resource_aws_finspace_kx_dataview, read_write when set to true, auto_update must be set to false."
  }
}

variable "segment_configurations" {
  description = "The configuration that contains the database path of the data that you want to place on each selected volume. Each segment must have a unique database path for each volume"
  type = list(object({
    db_paths    = list(string)
    volume_name = string
    on_demand   = optional(bool, false)
  }))
  default = []

  validation {
    condition = alltrue([
      for config in var.segment_configurations : length(config.db_paths) > 0
    ])
    error_message = "resource_aws_finspace_kx_dataview, segment_configurations each segment must have at least one db_paths."
  }

  validation {
    condition = alltrue([
      for config in var.segment_configurations : length(config.volume_name) > 0
    ])
    error_message = "resource_aws_finspace_kx_dataview, segment_configurations volume_name must not be empty."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level"
  type        = map(string)
  default     = {}
}

variable "create_timeout" {
  description = "Timeout for creating the dataview"
  type        = string
  default     = "4h"
}

variable "update_timeout" {
  description = "Timeout for updating the dataview"
  type        = string
  default     = "4h"
}

variable "delete_timeout" {
  description = "Timeout for deleting the dataview"
  type        = string
  default     = "4h"
}