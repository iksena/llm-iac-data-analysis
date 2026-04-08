variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "data_aws_emr_supported_instance_types, region must be a valid AWS region format (e.g., us-east-1) or null."
  }
}

variable "release_label" {
  description = "Amazon EMR release label. For more information about Amazon EMR releases and their included application versions and features, see the Amazon EMR Release Guide."
  type        = string

  validation {
    condition     = can(regex("^(emr-|ebs-)[0-9]+\\.[0-9]+\\.[0-9]+$", var.release_label))
    error_message = "data_aws_emr_supported_instance_types, release_label must be a valid EMR release label format (e.g., emr-6.15.0 or ebs-6.15.0)."
  }
}