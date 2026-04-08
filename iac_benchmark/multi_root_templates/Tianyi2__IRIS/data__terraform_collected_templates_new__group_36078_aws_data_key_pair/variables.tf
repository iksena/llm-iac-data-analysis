variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_key_pair, region must be a valid AWS region format (e.g., us-west-2)."
  }
}

variable "key_pair_id" {
  description = "Key Pair ID."
  type        = string
  default     = null

  validation {
    condition     = var.key_pair_id == null || length(var.key_pair_id) > 0
    error_message = "data_aws_key_pair, key_pair_id must not be empty if provided."
  }
}

variable "key_name" {
  description = "Key Pair name."
  type        = string
  default     = null

  validation {
    condition     = var.key_name == null || length(var.key_name) > 0
    error_message = "data_aws_key_pair, key_name must not be empty if provided."
  }
}

variable "include_public_key" {
  description = "Whether to include the public key material in the response."
  type        = bool
  default     = null

  validation {
    condition     = var.include_public_key == null || can(tobool(var.include_public_key))
    error_message = "data_aws_key_pair, include_public_key must be a boolean value."
  }
}

variable "filter" {
  description = "Custom filter block."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : length(f.name) > 0
    ])
    error_message = "data_aws_key_pair, filter name must not be empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_key_pair, filter values must not be empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : alltrue([
        for v in f.values : length(v) > 0
      ])
    ])
    error_message = "data_aws_key_pair, filter values must contain non-empty strings."
  }
}