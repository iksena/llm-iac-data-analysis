variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "cluster_identifier" {
  description = "The cluster identifier"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]*$", var.cluster_identifier))
    error_message = "resource_aws_rds_cluster_endpoint, cluster_identifier must start with a letter and contain only alphanumeric characters and hyphens."
  }
}

variable "cluster_endpoint_identifier" {
  description = "The identifier to use for the new endpoint. This parameter is stored as a lowercase string"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]*$", var.cluster_endpoint_identifier))
    error_message = "resource_aws_rds_cluster_endpoint, cluster_endpoint_identifier must start with a letter and contain only alphanumeric characters and hyphens."
  }
}

variable "custom_endpoint_type" {
  description = "The type of the endpoint. One of: READER, ANY"
  type        = string

  validation {
    condition     = contains(["READER", "ANY"], var.custom_endpoint_type)
    error_message = "resource_aws_rds_cluster_endpoint, custom_endpoint_type must be either READER or ANY."
  }
}

variable "static_members" {
  description = "List of DB instance identifiers that are part of the custom endpoint group. Conflicts with excluded_members"
  type        = list(string)
  default     = null

  validation {
    condition = var.static_members == null ? true : alltrue([
      for member in var.static_members : can(regex("^[a-zA-Z][a-zA-Z0-9-]*$", member))
    ])
    error_message = "resource_aws_rds_cluster_endpoint, static_members must contain valid DB instance identifiers that start with a letter and contain only alphanumeric characters and hyphens."
  }
}

variable "excluded_members" {
  description = "List of DB instance identifiers that aren't part of the custom endpoint group. All other eligible instances are reachable through the custom endpoint. Only relevant if the list of static members is empty. Conflicts with static_members"
  type        = list(string)
  default     = null

  validation {
    condition = var.excluded_members == null ? true : alltrue([
      for member in var.excluded_members : can(regex("^[a-zA-Z][a-zA-Z0-9-]*$", member))
    ])
    error_message = "resource_aws_rds_cluster_endpoint, excluded_members must contain valid DB instance identifiers that start with a letter and contain only alphanumeric characters and hyphens."
  }
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for key, value in var.tags : can(regex("^.{1,128}$", key)) && can(regex("^.{0,256}$", value))
    ])
    error_message = "resource_aws_rds_cluster_endpoint, tags keys must be 1-128 characters and values must be 0-256 characters."
  }
}