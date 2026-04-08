variable "name" {
  description = "The name of the global table. Must match underlying DynamoDB Table names in all regions."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255
    error_message = "resource_aws_dynamodb_global_table, name must be between 1 and 255 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]+$", var.name))
    error_message = "resource_aws_dynamodb_global_table, name must contain only alphanumeric characters, hyphens, underscores, and periods."
  }
}

variable "replica" {
  description = "Underlying DynamoDB Table. At least 1 replica must be defined."
  type = list(object({
    region_name = string
  }))

  validation {
    condition     = length(var.replica) >= 1
    error_message = "resource_aws_dynamodb_global_table, replica must have at least 1 replica defined."
  }

  validation {
    condition = alltrue([
      for r in var.replica : can(regex("^[a-z0-9-]+$", r.region_name))
    ])
    error_message = "resource_aws_dynamodb_global_table, replica region_name must be a valid AWS region name (e.g., us-east-1)."
  }

  validation {
    condition     = length(var.replica) == length(distinct([for r in var.replica : r.region_name]))
    error_message = "resource_aws_dynamodb_global_table, replica region_name values must be unique."
  }
}