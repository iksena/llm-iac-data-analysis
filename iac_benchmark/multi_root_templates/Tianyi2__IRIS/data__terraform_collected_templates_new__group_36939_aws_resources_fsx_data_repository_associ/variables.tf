variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "batch_import_meta_data_on_create" {
  description = "Set to true to run an import data repository task to import metadata from the data repository to the file system after the data repository association is created. Defaults to false."
  type        = bool
  default     = false
}

variable "data_repository_path" {
  description = "The path to the Amazon S3 data repository that will be linked to the file system. The path must be an S3 bucket s3://myBucket/myPrefix/. This path specifies where in the S3 data repository files will be imported from or exported to. The same S3 bucket cannot be linked more than once to the same file system."
  type        = string

  validation {
    condition     = can(regex("^s3://[a-zA-Z0-9.-]+(/.*)?$", var.data_repository_path))
    error_message = "resource_aws_fsx_data_repository_association, data_repository_path must be a valid S3 bucket path starting with s3://."
  }
}

variable "file_system_id" {
  description = "The ID of the Amazon FSx file system to on which to create a data repository association."
  type        = string

  validation {
    condition     = length(var.file_system_id) > 0
    error_message = "resource_aws_fsx_data_repository_association, file_system_id cannot be empty."
  }
}

variable "file_system_path" {
  description = "A path on the file system that points to a high-level directory (such as /ns1/) or subdirectory (such as /ns1/subdir/) that will be mapped 1-1 with data_repository_path. The leading forward slash in the name is required. Two data repository associations cannot have overlapping file system paths. For example, if a data repository is associated with file system path /ns1/, then you cannot link another data repository with file system path /ns1/ns2. This path specifies where in your file system files will be exported from or imported to. This file system directory can be linked to only one Amazon S3 bucket, and no other S3 bucket can be linked to the directory."
  type        = string

  validation {
    condition     = can(regex("^/.*", var.file_system_path))
    error_message = "resource_aws_fsx_data_repository_association, file_system_path must start with a forward slash (/)."
  }
}

variable "imported_file_chunk_size" {
  description = "For files imported from a data repository, this value determines the stripe count and maximum amount of data per file (in MiB) stored on a single physical disk. The maximum number of disks that a single file can be striped across is limited by the total number of disks that make up the file system."
  type        = number
  default     = null

  validation {
    condition     = var.imported_file_chunk_size == null || var.imported_file_chunk_size > 0
    error_message = "resource_aws_fsx_data_repository_association, imported_file_chunk_size must be greater than 0 when specified."
  }
}

variable "delete_data_in_filesystem" {
  description = "Set to true to delete files from the file system upon deleting this data repository association. Defaults to false."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the data repository association. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "s3" {
  description = "The configuration for an Amazon S3 data repository linked to an Amazon FSx Lustre file system with a data repository association. The configuration defines which file events (new, changed, or deleted files or directories) are automatically imported from the linked data repository to the file system or automatically exported from the file system to the data repository."
  type = object({
    auto_export_policy = optional(object({
      events = list(string)
    }))
    auto_import_policy = optional(object({
      events = list(string)
    }))
  })
  default = null

  validation {
    condition = var.s3 == null || (
      var.s3.auto_export_policy == null || (
        var.s3.auto_export_policy != null &&
        length(var.s3.auto_export_policy.events) <= 3 &&
        alltrue([for event in var.s3.auto_export_policy.events : contains(["NEW", "CHANGED", "DELETED"], event)])
      )
    )
    error_message = "resource_aws_fsx_data_repository_association, s3.auto_export_policy.events must contain valid events (NEW, CHANGED, DELETED) with max of 3 events."
  }

  validation {
    condition = var.s3 == null || (
      var.s3.auto_import_policy == null || (
        var.s3.auto_import_policy != null &&
        length(var.s3.auto_import_policy.events) <= 3 &&
        alltrue([for event in var.s3.auto_import_policy.events : contains(["NEW", "CHANGED", "DELETED"], event)])
      )
    )
    error_message = "resource_aws_fsx_data_repository_association, s3.auto_import_policy.events must contain valid events (NEW, CHANGED, DELETED) with max of 3 events."
  }
}