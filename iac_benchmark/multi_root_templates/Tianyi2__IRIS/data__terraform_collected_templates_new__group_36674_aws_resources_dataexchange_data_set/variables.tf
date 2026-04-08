variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "asset_type" {
  description = "The type of asset that is added to a data set."
  type        = string

  validation {
    condition     = contains(["API_GATEWAY_API", "LAKE_FORMATION_DATA_PERMISSION", "REDSHIFT_DATA_SHARE", "S3_DATA_ACCESS", "S3_SNAPSHOT"], var.asset_type)
    error_message = "resource_aws_dataexchange_data_set, asset_type must be one of: API_GATEWAY_API, LAKE_FORMATION_DATA_PERMISSION, REDSHIFT_DATA_SHARE, S3_DATA_ACCESS, S3_SNAPSHOT."
  }
}

variable "description" {
  description = "A description for the data set."
  type        = string
}

variable "name" {
  description = "The name of the data set."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}