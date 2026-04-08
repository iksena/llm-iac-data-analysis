variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "owners" {
  description = "List of AMI owners to limit search. At least 1 value must be specified. Valid values: an AWS account ID, 'self' (the current account), or an AWS owner alias (e.g., 'amazon', 'aws-marketplace', 'microsoft')."
  type        = list(string)

  validation {
    condition     = length(var.owners) >= 1
    error_message = "data_aws_ami_ids, owners must contain at least 1 value."
  }
}

variable "executable_users" {
  description = "Limit search to users with explicit launch permission on the image. Valid items are the numeric account ID or 'self'."
  type        = list(string)
  default     = null
}

variable "filter" {
  description = "One or more name/value pairs to filter off of. There are several valid keys, for a full reference, check out describe-images in the AWS CLI reference."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []
}

variable "name_regex" {
  description = "Regex string to apply to the AMI list returned by AWS. This allows more advanced filtering not supported from the AWS API. This filtering is done locally on what AWS returns, and could have a performance impact if the result is large. Combine this with other options to narrow down the list AWS returns."
  type        = string
  default     = null
}

variable "sort_ascending" {
  description = "Used to sort AMIs by creation time. If no value is specified, the default value is false."
  type        = bool
  default     = false
}

variable "include_deprecated" {
  description = "If true, all deprecated AMIs are included in the response. If false, no deprecated AMIs are included in the response. If no value is specified, the default value is false."
  type        = bool
  default     = false
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    read = optional(string, "20m")
  })
  default = {
    read = "20m"
  }
}