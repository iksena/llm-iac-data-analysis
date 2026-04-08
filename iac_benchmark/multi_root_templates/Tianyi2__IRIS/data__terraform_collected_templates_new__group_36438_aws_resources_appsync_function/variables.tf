variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "api_id" {
  description = "ID of the associated AppSync API."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9]+$", var.api_id))
    error_message = "resource_aws_appsync_function, api_id must be a valid AppSync API ID containing only alphanumeric characters."
  }
}

variable "code" {
  description = "The function code that contains the request and response functions. When code is used, the runtime is required. The runtime value must be APPSYNC_JS."
  type        = string
  default     = null
}

variable "data_source" {
  description = "Function data source name."
  type        = string

  validation {
    condition     = length(var.data_source) > 0
    error_message = "resource_aws_appsync_function, data_source cannot be empty."
  }
}

variable "max_batch_size" {
  description = "Maximum batching size for a resolver. Valid values are between 0 and 2000."
  type        = number
  default     = null

  validation {
    condition     = var.max_batch_size == null || (var.max_batch_size >= 0 && var.max_batch_size <= 2000)
    error_message = "resource_aws_appsync_function, max_batch_size must be between 0 and 2000."
  }
}

variable "name" {
  description = "Function name. The function name does not have to be unique."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_appsync_function, name cannot be empty."
  }
}

variable "request_mapping_template" {
  description = "Function request mapping template. Functions support only the 2018-05-29 version of the request mapping template."
  type        = string
  default     = null
}

variable "response_mapping_template" {
  description = "Function response mapping template."
  type        = string
  default     = null
}

variable "description" {
  description = "Function description."
  type        = string
  default     = null
}

variable "function_version" {
  description = "Version of the request mapping template. Currently the supported value is 2018-05-29. Does not apply when specifying code."
  type        = string
  default     = null

  validation {
    condition     = var.function_version == null || var.function_version == "2018-05-29"
    error_message = "resource_aws_appsync_function, function_version must be '2018-05-29'."
  }
}

variable "runtime" {
  description = "Describes a runtime used by an AWS AppSync pipeline resolver or AWS AppSync function. Specifies the name and version of the runtime to use."
  type = object({
    name            = optional(string)
    runtime_version = optional(string)
  })
  default = null

  validation {
    condition = var.runtime == null || (
      var.runtime.name == null || var.runtime.name == "APPSYNC_JS"
    )
    error_message = "resource_aws_appsync_function, runtime name must be 'APPSYNC_JS'."
  }

  validation {
    condition = var.runtime == null || (
      var.runtime.runtime_version == null || var.runtime.runtime_version == "1.0.0"
    )
    error_message = "resource_aws_appsync_function, runtime runtime_version must be '1.0.0'."
  }
}

variable "sync_config" {
  description = "Describes a Sync configuration for a resolver."
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
      var.sync_config.conflict_detection == null ||
      contains(["NONE", "VERSION"], var.sync_config.conflict_detection)
    )
    error_message = "resource_aws_appsync_function, sync_config conflict_detection must be 'NONE' or 'VERSION'."
  }

  validation {
    condition = var.sync_config == null || (
      var.sync_config.conflict_handler == null ||
      contains(["NONE", "OPTIMISTIC_CONCURRENCY", "AUTOMERGE", "LAMBDA"], var.sync_config.conflict_handler)
    )
    error_message = "resource_aws_appsync_function, sync_config conflict_handler must be 'NONE', 'OPTIMISTIC_CONCURRENCY', 'AUTOMERGE', or 'LAMBDA'."
  }
}