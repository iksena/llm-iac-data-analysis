variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the keyspace to be created."
  type        = string

  validation {
    condition     = var.name != null && var.name != ""
    error_message = "resource_aws_keyspaces_keyspace, name cannot be null or empty."
  }
}

variable "replication_specification" {
  description = "The replication specification of the keyspace."
  type = object({
    region_list          = optional(list(string))
    replication_strategy = string
  })
  default = null

  validation {
    condition = var.replication_specification == null || (
      var.replication_specification.replication_strategy != null &&
      contains(["SINGLE_REGION", "MULTI_REGION"], var.replication_specification.replication_strategy)
    )
    error_message = "resource_aws_keyspaces_keyspace, replication_strategy must be either 'SINGLE_REGION' or 'MULTI_REGION'."
  }

  validation {
    condition = var.replication_specification == null || (
      var.replication_specification.replication_strategy != "MULTI_REGION" ||
      (var.replication_specification.region_list != null && length(var.replication_specification.region_list) >= 2)
    )
    error_message = "resource_aws_keyspaces_keyspace, region_list requires the current Region and at least one additional AWS Region when replication_strategy is 'MULTI_REGION'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "timeouts_create" {
  description = "Create timeout for the keyspace resource."
  type        = string
  default     = "1m"
}

variable "timeouts_delete" {
  description = "Delete timeout for the keyspace resource."
  type        = string
  default     = "1m"
}