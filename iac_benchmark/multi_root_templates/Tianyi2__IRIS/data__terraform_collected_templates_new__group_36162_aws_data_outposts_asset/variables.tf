variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "arn" {
  description = "Outpost ARN."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:outposts:", var.arn))
    error_message = "data_aws_outposts_asset, arn must be a valid Outpost ARN starting with 'arn:aws:outposts:'."
  }
}

variable "asset_id" {
  description = "ID of the asset."
  type        = string

  validation {
    condition     = length(var.asset_id) > 0
    error_message = "data_aws_outposts_asset, asset_id cannot be empty."
  }
}