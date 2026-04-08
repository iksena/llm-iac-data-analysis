variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the resource share."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_ram_resource_share, name must not be empty."
  }
}

variable "allow_external_principals" {
  description = "Indicates whether principals outside your organization can be associated with a resource share."
  type        = bool
  default     = null
}

variable "permission_arns" {
  description = "Specifies the Amazon Resource Names (ARNs) of the RAM permission to associate with the resource share. If you do not specify an ARN for the permission, RAM automatically attaches the default version of the permission for each resource type. You can associate only one permission with each resource type included in the resource share."
  type        = list(string)
  default     = null

  validation {
    condition = var.permission_arns == null ? true : alltrue([
      for arn in var.permission_arns : can(regex("^arn:aws:ram:", arn))
    ])
    error_message = "resource_aws_ram_resource_share, permission_arns must be valid RAM permission ARNs starting with 'arn:aws:ram:'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource share. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}