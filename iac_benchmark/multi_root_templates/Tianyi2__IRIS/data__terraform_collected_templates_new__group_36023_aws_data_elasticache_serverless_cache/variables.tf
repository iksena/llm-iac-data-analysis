variable "name" {
  description = "Identifier for the serverless cache"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_elasticache_serverless_cache, name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}