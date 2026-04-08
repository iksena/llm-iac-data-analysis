variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_eip, region must be a valid AWS region identifier or null."
  }
}

variable "filter" {
  description = "One or more name/value pairs to use as filters. There are several valid keys, for a full reference, check out the EC2 API Reference."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_eip, filter name cannot be null or empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_eip, filter values must contain at least one element."
  }
}

variable "id" {
  description = "Allocation ID of the specific VPC EIP to retrieve. If a classic EIP is required, do NOT set id, only set public_ip."
  type        = string
  default     = null

  validation {
    condition     = var.id == null || can(regex("^eipalloc-[0-9a-f]+$", var.id))
    error_message = "data_aws_eip, id must be a valid EIP allocation ID in the format 'eipalloc-xxxxxxxx' or null."
  }
}

variable "public_ip" {
  description = "Public IP of the specific EIP to retrieve."
  type        = string
  default     = null

  validation {
    condition     = var.public_ip == null || can(cidrhost("${var.public_ip}/32", 0))
    error_message = "data_aws_eip, public_ip must be a valid IPv4 address or null."
  }
}

variable "tags" {
  description = "Map of tags, each pair of which must exactly match a pair on the desired Elastic IP."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : k != null && k != "" && v != null
    ])
    error_message = "data_aws_eip, tags keys and values cannot be null or empty strings."
  }
}

variable "read_timeout" {
  description = "Read timeout for the data source operation."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.read_timeout))
    error_message = "data_aws_eip, read_timeout must be a valid duration string (e.g., '20m', '1h', '30s')."
  }
}