variable "name" {
  description = "Name of the DynamoDB table"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_dynamodb_table, name must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || length(var.region) > 0
    error_message = "data_aws_dynamodb_table, region must be a non-empty string or null."
  }
}