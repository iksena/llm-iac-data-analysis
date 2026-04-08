variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "identity_pool_id" {
  description = "An identity pool ID in the format REGION_GUID"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+:[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.identity_pool_id))
    error_message = "resource_aws_cognito_identity_pool_roles_attachment, identity_pool_id must be in the format REGION_GUID."
  }
}

variable "roles" {
  description = "The map of roles associated with this pool. For a given role, the key will be either \"authenticated\" or \"unauthenticated\" and the value will be the Role ARN"
  type        = map(string)

  validation {
    condition = alltrue([
      for k, v in var.roles : contains(["authenticated", "unauthenticated"], k)
    ])
    error_message = "resource_aws_cognito_identity_pool_roles_attachment, roles keys must be either \"authenticated\" or \"unauthenticated\"."
  }

  validation {
    condition = alltrue([
      for k, v in var.roles : can(regex("^arn:aws:iam::[0-9]{12}:role/.+", v))
    ])
    error_message = "resource_aws_cognito_identity_pool_roles_attachment, roles values must be valid IAM role ARNs."
  }
}

variable "role_mapping" {
  description = "A List of Role Mapping configurations"
  type = list(object({
    identity_provider         = string
    ambiguous_role_resolution = optional(string)
    type                      = string
    mapping_rule = optional(list(object({
      claim      = string
      match_type = string
      role_arn   = string
      value      = string
    })))
  }))
  default = []

  validation {
    condition = alltrue([
      for mapping in var.role_mapping : contains(["Token", "Rules"], mapping.type)
    ])
    error_message = "resource_aws_cognito_identity_pool_roles_attachment, role_mapping type must be either \"Token\" or \"Rules\"."
  }

  validation {
    condition = alltrue([
      for mapping in var.role_mapping :
      mapping.type == "Token" || mapping.type == "Rules" ? mapping.ambiguous_role_resolution != null : true
    ])
    error_message = "resource_aws_cognito_identity_pool_roles_attachment, role_mapping ambiguous_role_resolution is required when type is \"Token\" or \"Rules\"."
  }

  validation {
    condition = alltrue([
      for mapping in var.role_mapping :
      mapping.mapping_rule != null ? length(mapping.mapping_rule) <= 25 : true
    ])
    error_message = "resource_aws_cognito_identity_pool_roles_attachment, role_mapping can specify up to 25 mapping rules per identity provider."
  }

  validation {
    condition = alltrue([
      for mapping in var.role_mapping :
      mapping.mapping_rule != null ? alltrue([
        for rule in mapping.mapping_rule : can(regex("^arn:aws:iam::[0-9]{12}:role/.+", rule.role_arn))
      ]) : true
    ])
    error_message = "resource_aws_cognito_identity_pool_roles_attachment, role_mapping mapping_rule role_arn must be a valid IAM role ARN."
  }
}