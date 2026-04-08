variable "data_set_id" {
  description = "Unique identifier for the data set associated with the revision"
  type        = string

  validation {
    condition     = length(var.data_set_id) > 0
    error_message = "resource_aws_dataexchange_revision_assets, data_set_id must not be empty."
  }
}

variable "asset" {
  description = "A block to define the asset associated with the revision"
  type = list(object({
    create_s3_data_access_from_s3_bucket = optional(object({
      asset_source = object({
        bucket       = string
        keys         = optional(list(string))
        key_prefixes = optional(list(string))
        kms_key_to_grant = optional(object({
          kms_key_arn = string
        }))
      })
    }))
    import_assets_from_s3 = optional(object({
      asset_source = object({
        bucket = string
        key    = string
      })
    }))
    import_assets_from_signed_url = optional(object({
      filename = string
    }))
  }))

  validation {
    condition     = length(var.asset) > 0
    error_message = "resource_aws_dataexchange_revision_assets, asset must contain at least one asset configuration."
  }

  validation {
    condition = alltrue([
      for a in var.asset :
      (a.create_s3_data_access_from_s3_bucket != null ? 1 : 0) +
      (a.import_assets_from_s3 != null ? 1 : 0) +
      (a.import_assets_from_signed_url != null ? 1 : 0) == 1
    ])
    error_message = "resource_aws_dataexchange_revision_assets, asset must specify exactly one of: create_s3_data_access_from_s3_bucket, import_assets_from_s3, or import_assets_from_signed_url."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "comment" {
  description = "A comment for the revision"
  type        = string
  default     = null

  validation {
    condition     = var.comment == null || length(var.comment) <= 16348
    error_message = "resource_aws_dataexchange_revision_assets, comment must not exceed 16,348 characters."
  }
}

variable "finalize" {
  description = "Finalized a revision"
  type        = bool
  default     = false
}

variable "force_destroy" {
  description = "Force destroy the revision"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}