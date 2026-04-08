variable "data_set_id" {
  description = "The dataset id"
  type        = string

  validation {
    condition     = length(var.data_set_id) > 0
    error_message = "resource_aws_dataexchange_revision, data_set_id cannot be empty."
  }
}

variable "comment" {
  description = "An optional comment about the revision"
  type        = string

  validation {
    condition     = length(var.comment) > 0
    error_message = "resource_aws_dataexchange_revision, comment cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_dataexchange_revision, region must be a valid AWS region format."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}

  validation {
    condition     = can(var.tags)
    error_message = "resource_aws_dataexchange_revision, tags must be a valid map of strings."
  }
}