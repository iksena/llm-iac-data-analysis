variable "description" {
  description = "Description of the source API being merged"
  type        = string
  default     = null
}

variable "merged_api_arn" {
  description = "ARN of the merged API. One of merged_api_arn or merged_api_id must be specified"
  type        = string
  default     = null
}

variable "merged_api_id" {
  description = "ID of the merged API. One of merged_api_arn or merged_api_id must be specified"
  type        = string
  default     = null
}

variable "source_api_arn" {
  description = "ARN of the source API. One of source_api_arn or source_api_id must be specified"
  type        = string
  default     = null
}

variable "source_api_id" {
  description = "ID of the source API. One of source_api_arn or source_api_id must be specified"
  type        = string
  default     = null
}

variable "source_api_association_config" {
  description = "Source API Association configuration block"
  type = object({
    merge_type = string
  })
  default = null

  validation {
    condition     = var.source_api_association_config == null || contains(["MANUAL_MERGE", "AUTO_MERGE"], var.source_api_association_config.merge_type)
    error_message = "resource_aws_appsync_source_api_association, source_api_association_config.merge_type: Valid values are MANUAL_MERGE or AUTO_MERGE."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string, "5m")
    update = optional(string, "5m")
    delete = optional(string, "5m")
  })
  default = {
    create = "5m"
    update = "5m"
    delete = "5m"
  }
}