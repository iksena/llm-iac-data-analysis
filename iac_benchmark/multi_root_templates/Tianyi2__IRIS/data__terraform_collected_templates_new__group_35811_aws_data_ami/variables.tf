variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "owners" {
  description = "List of AMI owners to limit search. Valid values: an AWS account ID, 'self' (the current account), or an AWS owner alias (e.g., 'amazon', 'aws-marketplace', 'microsoft')."
  type        = list(string)
  default     = null

  validation {
    condition = var.owners == null ? true : alltrue([
      for owner in var.owners : can(regex("^([0-9]{12}|self|amazon|aws-marketplace|microsoft)$", owner))
    ])
    error_message = "data_aws_ami, owners must be valid AWS account IDs (12 digits), 'self', or AWS owner aliases ('amazon', 'aws-marketplace', 'microsoft')."
  }
}

variable "most_recent" {
  description = "If more than one result is returned, use the most recent AMI."
  type        = bool
  default     = null
}

variable "executable_users" {
  description = "Limit search to users with explicit launch permission on the image. Valid items are the numeric account ID or 'self'."
  type        = list(string)
  default     = null

  validation {
    condition = var.executable_users == null ? true : alltrue([
      for user in var.executable_users : can(regex("^([0-9]{12}|self)$", user))
    ])
    error_message = "data_aws_ami, executable_users must be valid AWS account IDs (12 digits) or 'self'."
  }
}

variable "include_deprecated" {
  description = "If true, all deprecated AMIs are included in the response. If false, no deprecated AMIs are included in the response. If no value is specified, the default value is false."
  type        = bool
  default     = null
}

variable "filter" {
  description = "One or more name/value pairs to filter off of. There are several valid keys, for a full reference, check out describe-images in the AWS CLI reference."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = null

  validation {
    condition = var.filter == null ? true : alltrue([
      for f in var.filter : f.name != null && f.name != "" && f.values != null && length(f.values) > 0
    ])
    error_message = "data_aws_ami, filter blocks must have a non-empty name and at least one value."
  }
}

variable "allow_unsafe_filter" {
  description = "If true, allow unsafe filter values. With unsafe filters and most_recent set to true, a third party may introduce a new image which will be returned by this data source."
  type        = bool
  default     = null
}

variable "name_regex" {
  description = "Regex string to apply to the AMI list returned by AWS. This allows more advanced filtering not supported from the AWS API."
  type        = string
  default     = null

  validation {
    condition     = var.name_regex == null ? true : can(regex(var.name_regex, "test"))
    error_message = "data_aws_ami, name_regex must be a valid regular expression."
  }
}