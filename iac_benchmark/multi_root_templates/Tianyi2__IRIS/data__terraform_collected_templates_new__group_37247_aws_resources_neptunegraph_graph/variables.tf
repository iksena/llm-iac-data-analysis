variable "provisioned_memory" {
  description = "The provisioned memory-optimized Neptune Capacity Units (m-NCUs) to use for the graph."
  type        = number
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "deletion_protection" {
  description = "Value that indicates whether the Graph has deletion protection enabled. The graph can't be deleted when deletion protection is enabled."
  type        = bool
  default     = true
}

variable "graph_name" {
  description = "Contains a user-supplied name for the Graph. If omitted, Terraform will assign a random, unique identifier."
  type        = string
  default     = null
}

variable "public_connectivity" {
  description = "Specifies whether the Graph can be reached over the internet. Access to all graphs requires IAM authentication. When the Graph is publicly reachable, its Domain Name System (DNS) endpoint resolves to the public IP address from the internet. When the Graph isn't publicly reachable, you need to create a PrivateGraphEndpoint in a given VPC to ensure the DNS name resolves to a private IP address that is reachable from the VPC."
  type        = bool
  default     = false
}

variable "replica_count" {
  description = "Specifies the number of replicas you want when finished. All replicas will be provisioned in different availability zones. Replica Count should always be less than or equal to 2."
  type        = number
  default     = 1

  validation {
    condition     = var.replica_count >= 1 && var.replica_count <= 2
    error_message = "resource_aws_neptunegraph_graph, replica_count must be between 1 and 2."
  }
}

variable "kms_key_identifier" {
  description = "The ARN for the KMS encryption key. By Default, Neptune Analytics will use an AWS provided key (\"AWS_OWNED_KEY\"). This parameter is used if you want to encrypt the graph using a KMS Customer Managed Key (CMK)."
  type        = string
  default     = null
}

variable "vector_search_configuration" {
  description = "Vector Search Configuration"
  type = object({
    vector_search_dimension = number
  })
  default = null

  validation {
    condition = var.vector_search_configuration == null || (
      var.vector_search_configuration.vector_search_dimension >= 1 &&
      var.vector_search_configuration.vector_search_dimension <= 65535
    )
    error_message = "resource_aws_neptunegraph_graph, vector_search_dimension must be between 1 and 65,535."
  }
}

variable "tags" {
  description = "Key-value tags for the graph. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : length(k) >= 1 && length(k) <= 128 && !startswith(k, "aws:")
    ])
    error_message = "resource_aws_neptunegraph_graph, tag keys must be 1 to 128 characters in length and cannot be prefixed with aws:."
  }

  validation {
    condition = alltrue([
      for k, v in var.tags : length(v) <= 256 && !startswith(v, "aws:")
    ])
    error_message = "resource_aws_neptunegraph_graph, tag values must be 0 to 256 characters in length and cannot be prefixed with aws:."
  }
}

variable "timeouts" {
  description = "Configuration options for resource timeouts"
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}