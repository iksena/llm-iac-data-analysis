variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "filter" {
  description = "Configuration block(s) for filtering"
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = null

  validation {
    condition = var.filter == null || alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_secretsmanager_secrets, filter: name is required and cannot be empty."
  }

  validation {
    condition = var.filter == null || alltrue([
      for f in var.filter : f.values != null && length(f.values) > 0
    ])
    error_message = "data_aws_secretsmanager_secrets, filter: values is required and cannot be empty."
  }
}