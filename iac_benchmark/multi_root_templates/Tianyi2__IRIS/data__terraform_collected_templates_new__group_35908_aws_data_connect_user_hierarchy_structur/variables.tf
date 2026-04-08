variable "instance_id" {
  description = "Reference to the hosting Amazon Connect Instance"
  type        = string

  validation {
    condition     = can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.instance_id))
    error_message = "data_aws_connect_user_hierarchy_structure, instance_id must be a valid UUID format."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$|^us-gov-[a-z]+-[0-9]$|^cn-[a-z]+-[0-9]$", var.region))
    error_message = "data_aws_connect_user_hierarchy_structure, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}