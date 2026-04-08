variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "connection_alias" {
  description = "Specifies the connection alias that will be used by the customer for this connection."
  type        = string

  validation {
    condition     = length(var.connection_alias) > 0
    error_message = "resource_aws_opensearch_outbound_connection, connection_alias cannot be empty."
  }
}

variable "connection_mode" {
  description = "Specifies the connection mode. Accepted values are DIRECT or VPC_ENDPOINT."
  type        = string

  validation {
    condition     = contains(["DIRECT", "VPC_ENDPOINT"], var.connection_mode)
    error_message = "resource_aws_opensearch_outbound_connection, connection_mode must be either DIRECT or VPC_ENDPOINT."
  }
}

variable "accept_connection" {
  description = "Accepts the connection."
  type        = bool
  default     = null
}

variable "connection_properties" {
  description = "Configuration block for the outbound connection."
  type = object({
    cross_cluster_search = optional(object({
      skip_unavailable = optional(string)
    }))
  })
  default = null

  validation {
    condition = var.connection_properties == null || (
      var.connection_properties.cross_cluster_search == null ||
      var.connection_properties.cross_cluster_search.skip_unavailable == null ||
      contains(["ENABLED", "DISABLED"], var.connection_properties.cross_cluster_search.skip_unavailable)
    )
    error_message = "resource_aws_opensearch_outbound_connection, connection_properties.cross_cluster_search.skip_unavailable must be either ENABLED or DISABLED."
  }
}

variable "local_domain_info" {
  description = "Configuration block for the local Opensearch domain."
  type = object({
    owner_id    = string
    domain_name = string
    region      = string
  })

  validation {
    condition     = length(var.local_domain_info.owner_id) > 0
    error_message = "resource_aws_opensearch_outbound_connection, local_domain_info.owner_id cannot be empty."
  }

  validation {
    condition     = length(var.local_domain_info.domain_name) > 0
    error_message = "resource_aws_opensearch_outbound_connection, local_domain_info.domain_name cannot be empty."
  }

  validation {
    condition     = length(var.local_domain_info.region) > 0
    error_message = "resource_aws_opensearch_outbound_connection, local_domain_info.region cannot be empty."
  }
}

variable "remote_domain_info" {
  description = "Configuration block for the remote Opensearch domain."
  type = object({
    owner_id    = string
    domain_name = string
    region      = string
  })

  validation {
    condition     = length(var.remote_domain_info.owner_id) > 0
    error_message = "resource_aws_opensearch_outbound_connection, remote_domain_info.owner_id cannot be empty."
  }

  validation {
    condition     = length(var.remote_domain_info.domain_name) > 0
    error_message = "resource_aws_opensearch_outbound_connection, remote_domain_info.domain_name cannot be empty."
  }

  validation {
    condition     = length(var.remote_domain_info.region) > 0
    error_message = "resource_aws_opensearch_outbound_connection, remote_domain_info.region cannot be empty."
  }
}