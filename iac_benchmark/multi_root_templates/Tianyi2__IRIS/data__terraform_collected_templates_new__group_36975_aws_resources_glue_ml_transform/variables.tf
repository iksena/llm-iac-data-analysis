variable "name" {
  description = "The name you assign to this ML Transform. It must be unique in your account."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_glue_ml_transform, name must not be empty."
  }
}

variable "role_arn" {
  description = "The ARN of the IAM role associated with this ML Transform."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::", var.role_arn))
    error_message = "resource_aws_glue_ml_transform, role_arn must be a valid IAM role ARN."
  }
}

variable "input_record_tables" {
  description = "A list of AWS Glue table definitions used by the transform."
  type = list(object({
    database_name   = string
    table_name      = string
    catalog_id      = optional(string)
    connection_name = optional(string)
  }))

  validation {
    condition     = length(var.input_record_tables) > 0
    error_message = "resource_aws_glue_ml_transform, input_record_tables must contain at least one table definition."
  }

  validation {
    condition = alltrue([
      for table in var.input_record_tables : length(table.database_name) > 0
    ])
    error_message = "resource_aws_glue_ml_transform, input_record_tables database_name must not be empty."
  }

  validation {
    condition = alltrue([
      for table in var.input_record_tables : length(table.table_name) > 0
    ])
    error_message = "resource_aws_glue_ml_transform, input_record_tables table_name must not be empty."
  }
}

variable "parameters" {
  description = "The algorithmic parameters that are specific to the transform type used."
  type = object({
    transform_type = string
    find_matches_parameters = optional(object({
      accuracy_cost_trade_off    = optional(number)
      enforce_provided_labels    = optional(bool)
      precision_recall_trade_off = optional(number)
      primary_key_column_name    = optional(string)
    }))
  })

  validation {
    condition     = length(var.parameters.transform_type) > 0
    error_message = "resource_aws_glue_ml_transform, parameters transform_type must not be empty."
  }
}

variable "description" {
  description = "Description of the ML Transform."
  type        = string
  default     = null
}

variable "glue_version" {
  description = "The version of glue to use, for example \"1.0\"."
  type        = string
  default     = null
}

variable "max_capacity" {
  description = "The number of AWS Glue data processing units (DPUs) that are allocated to task runs for this transform. You can allocate from 2 to 100 DPUs; the default is 10."
  type        = number
  default     = null

  validation {
    condition     = var.max_capacity == null || (var.max_capacity >= 2 && var.max_capacity <= 100)
    error_message = "resource_aws_glue_ml_transform, max_capacity must be between 2 and 100 DPUs."
  }
}

variable "max_retries" {
  description = "The maximum number of times to retry this ML Transform if it fails."
  type        = number
  default     = null

  validation {
    condition     = var.max_retries == null || var.max_retries >= 0
    error_message = "resource_aws_glue_ml_transform, max_retries must be greater than or equal to 0."
  }
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}

variable "timeout" {
  description = "The ML Transform timeout in minutes. The default is 2880 minutes (48 hours)."
  type        = number
  default     = null

  validation {
    condition     = var.timeout == null || var.timeout > 0
    error_message = "resource_aws_glue_ml_transform, timeout must be greater than 0."
  }
}

variable "worker_type" {
  description = "The type of predefined worker that is allocated when an ML Transform runs. Accepts a value of Standard, G.1X, or G.2X."
  type        = string
  default     = null

  validation {
    condition     = var.worker_type == null || contains(["Standard", "G.1X", "G.2X"], var.worker_type)
    error_message = "resource_aws_glue_ml_transform, worker_type must be one of: Standard, G.1X, G.2X."
  }
}

variable "number_of_workers" {
  description = "The number of workers of a defined worker_type that are allocated when an ML Transform runs."
  type        = number
  default     = null

  validation {
    condition     = var.number_of_workers == null || var.number_of_workers > 0
    error_message = "resource_aws_glue_ml_transform, number_of_workers must be greater than 0."
  }

  validation {
    condition     = (var.worker_type == null && var.number_of_workers == null) || (var.worker_type != null && var.number_of_workers != null)
    error_message = "resource_aws_glue_ml_transform, number_of_workers and worker_type must be used together."
  }
}