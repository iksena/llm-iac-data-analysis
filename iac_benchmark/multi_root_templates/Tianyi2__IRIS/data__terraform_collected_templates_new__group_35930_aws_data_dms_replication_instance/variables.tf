variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "replication_instance_id" {
  description = "The replication instance identifier."
  type        = string

  validation {
    condition     = length(var.replication_instance_id) > 0
    error_message = "data_aws_dms_replication_instance, replication_instance_id must be a non-empty string."
  }
}