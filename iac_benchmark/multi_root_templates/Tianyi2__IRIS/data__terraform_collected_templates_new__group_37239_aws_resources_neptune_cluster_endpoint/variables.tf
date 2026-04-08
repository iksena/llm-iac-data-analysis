variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cluster_identifier" {
  description = "The DB cluster identifier of the DB cluster associated with the endpoint."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]*$", var.cluster_identifier)) && length(var.cluster_identifier) >= 1 && length(var.cluster_identifier) <= 63
    error_message = "resource_aws_neptune_cluster_endpoint, cluster_identifier must be a valid cluster identifier."
  }
}

variable "cluster_endpoint_identifier" {
  description = "The identifier of the endpoint."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]*$", var.cluster_endpoint_identifier)) && length(var.cluster_endpoint_identifier) >= 1 && length(var.cluster_endpoint_identifier) <= 63
    error_message = "resource_aws_neptune_cluster_endpoint, cluster_endpoint_identifier must be a valid endpoint identifier."
  }
}

variable "endpoint_type" {
  description = "The type of the endpoint. One of: READER, WRITER, ANY."
  type        = string

  validation {
    condition     = contains(["READER", "WRITER", "ANY"], var.endpoint_type)
    error_message = "resource_aws_neptune_cluster_endpoint, endpoint_type must be one of: READER, WRITER, ANY."
  }
}

variable "excluded_members" {
  description = "List of DB instance identifiers that aren't part of the custom endpoint group. All other eligible instances are reachable through the custom endpoint. Only relevant if the list of static members is empty."
  type        = list(string)
  default     = null

  validation {
    condition = var.excluded_members == null || (
      var.excluded_members != null &&
      length(var.excluded_members) > 0 &&
      alltrue([for member in var.excluded_members : can(regex("^[a-zA-Z][a-zA-Z0-9-]*$", member))])
    )
    error_message = "resource_aws_neptune_cluster_endpoint, excluded_members must be a list of valid DB instance identifiers."
  }
}

variable "static_members" {
  description = "List of DB instance identifiers that are part of the custom endpoint group."
  type        = list(string)
  default     = null

  validation {
    condition = var.static_members == null || (
      var.static_members != null &&
      length(var.static_members) > 0 &&
      alltrue([for member in var.static_members : can(regex("^[a-zA-Z][a-zA-Z0-9-]*$", member))])
    )
    error_message = "resource_aws_neptune_cluster_endpoint, static_members must be a list of valid DB instance identifiers."
  }
}

variable "tags" {
  description = "A map of tags to assign to the Neptune cluster. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{1,128}$", k)) && can(regex("^.{0,256}$", v))
    ])
    error_message = "resource_aws_neptune_cluster_endpoint, tags keys must be 1-128 characters and values must be 0-256 characters."
  }
}