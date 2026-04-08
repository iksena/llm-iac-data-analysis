variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "sink_identifier" {
  description = "ARN of the sink to attach this policy to."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:oam:[a-z0-9-]+:[0-9]+:sink/.+", var.sink_identifier))
    error_message = "resource_aws_oam_sink_policy, sink_identifier must be a valid OAM sink ARN."
  }
}

variable "policy" {
  description = "JSON policy to use. If you are updating an existing policy, the entire existing policy is replaced by what you specify here."
  type        = string

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_oam_sink_policy, policy must be valid JSON."
  }
}

variable "timeouts_create" {
  description = "Timeout for create operation"
  type        = string
  default     = "1m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_oam_sink_policy, timeouts_create must be a valid timeout duration (e.g., '1m', '30s', '1h')."
  }
}

variable "timeouts_update" {
  description = "Timeout for update operation"
  type        = string
  default     = "1m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_update))
    error_message = "resource_aws_oam_sink_policy, timeouts_update must be a valid timeout duration (e.g., '1m', '30s', '1h')."
  }
}