variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cpu_credits" {
  description = "Credit option for CPU usage of the instance family. Valid values: standard, unlimited."
  type        = string

  validation {
    condition     = contains(["standard", "unlimited"], var.cpu_credits)
    error_message = "resource_aws_ec2_default_credit_specification, cpu_credits must be one of: standard, unlimited."
  }
}

variable "instance_family" {
  description = "Instance family. Valid values are t2, t3, t3a, t4g."
  type        = string

  validation {
    condition     = contains(["t2", "t3", "t3a", "t4g"], var.instance_family)
    error_message = "resource_aws_ec2_default_credit_specification, instance_family must be one of: t2, t3, t3a, t4g."
  }
}

variable "create_timeout" {
  description = "Timeout for create operation."
  type        = string
  default     = "30m"
}

variable "update_timeout" {
  description = "Timeout for update operation."
  type        = string
  default     = "30m"
}