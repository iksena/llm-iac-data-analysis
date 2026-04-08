variable "global_network_id" {
  description = "ID of the global network that a core network will be a part of"
  type        = string

  validation {
    condition     = can(regex("^global-network-[0-9a-f]{17}$", var.global_network_id))
    error_message = "resource_aws_networkmanager_core_network, global_network_id must be a valid global network ID format (e.g., global-network-0123456789abcdef0)."
  }
}

variable "base_policy_document" {
  description = "Sets the base policy document for the core network (conflicts with base_policy_regions)"
  type        = string
  default     = null

  validation {
    condition = var.base_policy_document == null || (
      can(jsondecode(var.base_policy_document)) &&
      can(jsondecode(var.base_policy_document).version) &&
      can(jsondecode(var.base_policy_document)["core-network-configuration"]) &&
      can(jsondecode(var.base_policy_document).segments)
    )
    error_message = "resource_aws_networkmanager_core_network, base_policy_document must be a valid JSON document with required fields: version, core-network-configuration, and segments."
  }
}

variable "base_policy_regions" {
  description = "List of regions to add to the base policy (conflicts with base_policy_document)"
  type        = list(string)
  default     = null

  validation {
    condition = var.base_policy_regions == null || (
      length(var.base_policy_regions) > 0 &&
      alltrue([for region in var.base_policy_regions : can(regex("^[a-z]+-[a-z]+-[0-9]+$", region))])
    )
    error_message = "resource_aws_networkmanager_core_network, base_policy_regions must be a non-empty list of valid AWS regions (e.g., us-east-1, us-west-2)."
  }
}

variable "create_base_policy" {
  description = "Whether to create a base policy when a core network is created or updated"
  type        = bool
  default     = null
}

variable "description" {
  description = "Description of the Core Network"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || (length(var.description) >= 0 && length(var.description) <= 256)
    error_message = "resource_aws_networkmanager_core_network, description must be between 0 and 256 characters."
  }
}

variable "tags" {
  description = "Key-value tags for the Core Network"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : length(k) <= 128 && length(v) <= 256 &&
      can(regex("^[a-zA-Z0-9\\s_.:/=+\\-@]*$", k)) &&
      can(regex("^[a-zA-Z0-9\\s_.:/=+\\-@]*$", v))
    ])
    error_message = "resource_aws_networkmanager_core_network, tags keys must be <= 128 characters and values <= 256 characters, containing only alphanumeric characters, spaces, and the following characters: _.:/=+-@"
  }
}

variable "timeouts" {
  description = "Configuration block with timeout values for create, delete, and update operations"
  type = object({
    create = optional(string, "30m")
    delete = optional(string, "30m")
    update = optional(string, "30m")
  })
  default = null

  validation {
    condition = var.timeouts == null || alltrue([
      for timeout in [var.timeouts.create, var.timeouts.delete, var.timeouts.update] :
      timeout == null || can(regex("^[0-9]+[smh]$", timeout))
    ])
    error_message = "resource_aws_networkmanager_core_network, timeouts must be valid duration strings (e.g., 30m, 1h, 120s)."
  }
}