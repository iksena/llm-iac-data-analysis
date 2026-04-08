variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the Snapshot. You can use a maximum of 203 alphanumeric characters plus either _ or -  or : or . for the name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_\\-:\\.]{1,203}$", var.name))
    error_message = "resource_aws_fsx_openzfs_snapshot, name must be a maximum of 203 alphanumeric characters plus either _ or -  or : or . for the name."
  }
}

variable "tags" {
  description = "A map of tags to assign to the file system. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "volume_id" {
  description = "The ID of the volume to snapshot. This can be the root volume or a child volume."
  type        = string
  default     = null
}