variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "http_endpoint" {
  description = "Whether the metadata service is available. Can be 'enabled', 'disabled', or 'no-preference'."
  type        = string
  default     = "no-preference"

  validation {
    condition     = contains(["enabled", "disabled", "no-preference"], var.http_endpoint)
    error_message = "resource_aws_ec2_instance_metadata_defaults, http_endpoint must be one of: 'enabled', 'disabled', or 'no-preference'."
  }
}

variable "http_tokens" {
  description = "Whether the metadata service requires session tokens, also referred to as Instance Metadata Service Version 2 (IMDSv2). Can be 'optional', 'required', or 'no-preference'."
  type        = string
  default     = "no-preference"

  validation {
    condition     = contains(["optional", "required", "no-preference"], var.http_tokens)
    error_message = "resource_aws_ec2_instance_metadata_defaults, http_tokens must be one of: 'optional', 'required', or 'no-preference'."
  }
}

variable "http_put_response_hop_limit" {
  description = "The desired HTTP PUT response hop limit for instance metadata requests. The larger the number, the further instance metadata requests can travel. Can be an integer from 1 to 64, or -1 to indicate no preference."
  type        = number
  default     = -1

  validation {
    condition     = var.http_put_response_hop_limit == -1 || (var.http_put_response_hop_limit >= 1 && var.http_put_response_hop_limit <= 64)
    error_message = "resource_aws_ec2_instance_metadata_defaults, http_put_response_hop_limit must be an integer from 1 to 64, or -1 to indicate no preference."
  }
}

variable "instance_metadata_tags" {
  description = "Enables or disables access to instance tags from the instance metadata service. Can be 'enabled', 'disabled', or 'no-preference'."
  type        = string
  default     = "no-preference"

  validation {
    condition     = contains(["enabled", "disabled", "no-preference"], var.instance_metadata_tags)
    error_message = "resource_aws_ec2_instance_metadata_defaults, instance_metadata_tags must be one of: 'enabled', 'disabled', or 'no-preference'."
  }
}