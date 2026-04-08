variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the query"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_cloudwatch_query_definition, name must be a non-empty string."
  }
}

variable "query_string" {
  description = "The query to save. You can read more about CloudWatch Logs Query Syntax in the documentation"
  type        = string

  validation {
    condition     = length(var.query_string) > 0
    error_message = "resource_aws_cloudwatch_query_definition, query_string must be a non-empty string."
  }
}

variable "log_group_names" {
  description = "Specific log groups to use with the query"
  type        = list(string)
  default     = null

  validation {
    condition = var.log_group_names == null || (
      length(var.log_group_names) > 0 &&
      alltrue([for name in var.log_group_names : length(name) > 0])
    )
    error_message = "resource_aws_cloudwatch_query_definition, log_group_names must be null or a non-empty list of non-empty strings."
  }
}