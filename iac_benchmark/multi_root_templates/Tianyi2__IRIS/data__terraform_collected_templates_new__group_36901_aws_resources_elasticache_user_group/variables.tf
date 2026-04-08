variable "engine" {
  description = "The current supported value are redis, valkey (case insensitive)"
  type        = string

  validation {
    condition     = contains(["redis", "valkey", "REDIS", "VALKEY", "Redis", "Valkey"], var.engine)
    error_message = "resource_aws_elasticache_user_group, engine must be redis or valkey (case insensitive)."
  }
}

variable "user_group_id" {
  description = "The ID of the user group"
  type        = string

  validation {
    condition     = length(var.user_group_id) > 0
    error_message = "resource_aws_elasticache_user_group, user_group_id cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "user_ids" {
  description = "The list of user IDs that belong to the user group"
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}