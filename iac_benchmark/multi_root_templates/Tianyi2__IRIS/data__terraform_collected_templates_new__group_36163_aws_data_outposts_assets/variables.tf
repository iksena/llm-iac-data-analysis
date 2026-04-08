variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "arn" {
  description = "Outpost ARN."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:outposts:[a-z0-9-]+:[0-9]{12}:outpost/op-[a-z0-9]+$", var.arn))
    error_message = "data_aws_outposts_assets, arn must be a valid Outpost ARN format."
  }
}

variable "host_id_filter" {
  description = "Filters by list of Host IDs of a Dedicated Host."
  type        = list(string)
  default     = null

  validation {
    condition = var.host_id_filter == null ? true : alltrue([
      for host_id in var.host_id_filter : can(regex("^h-[a-z0-9]+$", host_id))
    ])
    error_message = "data_aws_outposts_assets, host_id_filter must contain valid Host ID formats (h-xxxxxxxxxx)."
  }
}

variable "status_id_filter" {
  description = "Filters by list of state status. Valid values: \"ACTIVE\", \"RETIRING\"."
  type        = list(string)
  default     = null

  validation {
    condition = var.status_id_filter == null ? true : alltrue([
      for status in var.status_id_filter : contains(["ACTIVE", "RETIRING"], status)
    ])
    error_message = "data_aws_outposts_assets, status_id_filter must contain only valid values: \"ACTIVE\", \"RETIRING\"."
  }
}