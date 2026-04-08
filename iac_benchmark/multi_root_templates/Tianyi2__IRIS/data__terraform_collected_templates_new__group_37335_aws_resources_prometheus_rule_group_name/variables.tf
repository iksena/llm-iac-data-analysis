variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "data" {
  description = "The rule group namespace data that you want to be applied."
  type        = string

  validation {
    condition     = var.data != null && var.data != ""
    error_message = "resource_aws_prometheus_rule_group_namespace, data must be provided and cannot be empty."
  }
}

variable "name" {
  description = "The name of the rule group namespace."
  type        = string

  validation {
    condition     = var.name != null && var.name != ""
    error_message = "resource_aws_prometheus_rule_group_namespace, name must be provided and cannot be empty."
  }
}

variable "tags" {
  description = "Map of tags assigned to the resource."
  type        = map(string)
  default     = {}
}

variable "workspace_id" {
  description = "ID of the prometheus workspace the rule group namespace should be linked to."
  type        = string

  validation {
    condition     = var.workspace_id != null && var.workspace_id != ""
    error_message = "resource_aws_prometheus_rule_group_namespace, workspace_id must be provided and cannot be empty."
  }
}