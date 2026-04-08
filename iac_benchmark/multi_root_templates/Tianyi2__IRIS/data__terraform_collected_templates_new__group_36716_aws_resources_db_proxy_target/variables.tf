variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "db_proxy_name" {
  description = "The name of the DB proxy."
  type        = string

  validation {
    condition     = length(var.db_proxy_name) > 0
    error_message = "resource_aws_db_proxy_target, db_proxy_name must not be empty."
  }
}

variable "target_group_name" {
  description = "The name of the target group."
  type        = string

  validation {
    condition     = length(var.target_group_name) > 0
    error_message = "resource_aws_db_proxy_target, target_group_name must not be empty."
  }
}

variable "db_instance_identifier" {
  description = "DB instance identifier."
  type        = string
  default     = null
}

variable "db_cluster_identifier" {
  description = "DB cluster identifier."
  type        = string
  default     = null

  validation {
    condition     = (var.db_instance_identifier != null && var.db_cluster_identifier == null) || (var.db_instance_identifier == null && var.db_cluster_identifier != null)
    error_message = "resource_aws_db_proxy_target, db_instance_identifier and db_cluster_identifier cannot both be specified. Either db_instance_identifier or db_cluster_identifier should be specified."
  }
}