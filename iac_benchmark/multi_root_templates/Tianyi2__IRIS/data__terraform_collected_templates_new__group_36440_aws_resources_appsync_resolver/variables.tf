variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "api_id" {
  description = "API ID for the GraphQL API"
  type        = string

  validation {
    condition     = length(var.api_id) > 0
    error_message = "resource_aws_appsync_resolver, api_id must not be empty."
  }
}

variable "code" {
  description = "The function code that contains the request and response functions"
  type        = string
  default     = null
}

variable "type" {
  description = "Type name from the schema defined in the GraphQL API"
  type        = string

  validation {
    condition     = length(var.type) > 0
    error_message = "resource_aws_appsync_resolver, type must not be empty."
  }
}

variable "field" {
  description = "Field name from the schema defined in the GraphQL API"
  type        = string

  validation {
    condition     = length(var.field) > 0
    error_message = "resource_aws_appsync_resolver, field must not be empty."
  }
}

variable "request_template" {
  description = "Request mapping template for UNIT resolver or 'before mapping template' for PIPELINE resolver"
  type        = string
  default     = null
}

variable "response_template" {
  description = "Response mapping template for UNIT resolver or 'after mapping template' for PIPELINE resolver"
  type        = string
  default     = null
}

variable "data_source" {
  description = "Data source name"
  type        = string
  default     = null
}

variable "max_batch_size" {
  description = "Maximum batching size for a resolver"
  type        = number
  default     = null

  validation {
    condition     = var.max_batch_size == null || (var.max_batch_size >= 0 && var.max_batch_size <= 2000)
    error_message = "resource_aws_appsync_resolver, max_batch_size must be between 0 and 2000."
  }
}

variable "kind" {
  description = "Resolver type"
  type        = string
  default     = "UNIT"

  validation {
    condition     = contains(["UNIT", "PIPELINE"], var.kind)
    error_message = "resource_aws_appsync_resolver, kind must be either 'UNIT' or 'PIPELINE'."
  }
}

variable "sync_config" {
  description = "Describes a Sync configuration for a resolver"
  type = object({
    conflict_detection = optional(string)
    conflict_handler   = optional(string)
    lambda_conflict_handler_config = optional(object({
      lambda_conflict_handler_arn = optional(string)
    }))
  })
  default = null

  validation {
    condition = var.sync_config == null || (
      var.sync_config.conflict_detection == null || contains(["NONE", "VERSION"], var.sync_config.conflict_detection)
    )
    error_message = "resource_aws_appsync_resolver, sync_config.conflict_detection must be 'NONE' or 'VERSION'."
  }

  validation {
    condition = var.sync_config == null || (
      var.sync_config.conflict_handler == null || contains(["NONE", "OPTIMISTIC_CONCURRENCY", "AUTOMERGE", "LAMBDA"], var.sync_config.conflict_handler)
    )
    error_message = "resource_aws_appsync_resolver, sync_config.conflict_handler must be 'NONE', 'OPTIMISTIC_CONCURRENCY', 'AUTOMERGE', or 'LAMBDA'."
  }
}

variable "pipeline_config" {
  description = "The caching configuration for the resolver"
  type = object({
    functions = optional(list(string))
  })
  default = null
}

variable "caching_config" {
  description = "The Caching Config"
  type = object({
    caching_keys = optional(list(string))
    ttl          = optional(number)
  })
  default = null

  validation {
    condition = var.caching_config == null || (
      var.caching_config.ttl == null || (var.caching_config.ttl >= 1 && var.caching_config.ttl <= 3600)
    )
    error_message = "resource_aws_appsync_resolver, caching_config.ttl must be between 1 and 3600 seconds."
  }
}

variable "runtime" {
  description = "Describes a runtime used by an AWS AppSync pipeline resolver or AWS AppSync function"
  type = object({
    name            = optional(string)
    runtime_version = optional(string)
  })
  default = null

  validation {
    condition = var.runtime == null || (
      var.runtime.name == null || var.runtime.name == "APPSYNC_JS"
    )
    error_message = "resource_aws_appsync_resolver, runtime.name must be 'APPSYNC_JS'."
  }

  validation {
    condition = var.runtime == null || (
      var.runtime.runtime_version == null || var.runtime.runtime_version == "1.0.0"
    )
    error_message = "resource_aws_appsync_resolver, runtime.runtime_version must be '1.0.0'."
  }
}