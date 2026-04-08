variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "instance_type" {
  description = "Instance type"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+\\.[a-z0-9]+$", var.instance_type))
    error_message = "data_aws_ec2_instance_type, instance_type must be a valid EC2 instance type format (e.g., t2.micro, m5.large)."
  }
}