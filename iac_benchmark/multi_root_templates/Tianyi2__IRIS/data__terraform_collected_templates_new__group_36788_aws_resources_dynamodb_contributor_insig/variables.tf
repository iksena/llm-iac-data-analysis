variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "table_name" {
  description = "The name of the table to enable contributor insights"
  type        = string

  validation {
    condition     = length(var.table_name) > 0
    error_message = "resource_aws_dynamodb_contributor_insights, table_name must not be empty."
  }
}

variable "index_name" {
  description = "The global secondary index name"
  type        = string
  default     = null
}

variable "mode" {
  description = "CloudWatch contributor insights mode"
  type        = string
  default     = null
}