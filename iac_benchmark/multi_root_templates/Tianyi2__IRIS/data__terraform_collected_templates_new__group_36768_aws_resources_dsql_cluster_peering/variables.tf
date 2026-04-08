variable "clusters" {
  description = "List of DSQL Cluster ARNs to be peered to this cluster"
  type        = list(string)

  validation {
    condition     = length(var.clusters) > 0
    error_message = "resource_aws_dsql_cluster_peering, clusters must contain at least one cluster ARN."
  }

  validation {
    condition = alltrue([
      for cluster in var.clusters : can(regex("^arn:aws:dsql:", cluster))
    ])
    error_message = "resource_aws_dsql_cluster_peering, clusters must be valid DSQL cluster ARNs starting with 'arn:aws:dsql:'."
  }
}

variable "identifier" {
  description = "DSQL Cluster Identifier"
  type        = string

  validation {
    condition     = length(var.identifier) > 0
    error_message = "resource_aws_dsql_cluster_peering, identifier cannot be empty."
  }

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]*$", var.identifier))
    error_message = "resource_aws_dsql_cluster_peering, identifier must start with a letter and contain only letters, numbers, and hyphens."
  }

  validation {
    condition     = length(var.identifier) <= 63
    error_message = "resource_aws_dsql_cluster_peering, identifier must be 63 characters or less."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_dsql_cluster_peering, region must be a valid AWS region format when specified."
  }
}

variable "witness_region" {
  description = "Witness region for a multi-region cluster"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.witness_region))
    error_message = "resource_aws_dsql_cluster_peering, witness_region must be a valid AWS region format."
  }
}

variable "timeouts" {
  description = "Configuration options for resource timeouts"
  type = object({
    create = optional(string, "30m")
  })
  default = null

  validation {
    condition = var.timeouts == null || (
      var.timeouts.create == null || can(regex("^[0-9]+[smh]$", var.timeouts.create))
    )
    error_message = "resource_aws_dsql_cluster_peering, timeouts.create must be a valid duration format (e.g., '30m', '1h', '300s')."
  }
}