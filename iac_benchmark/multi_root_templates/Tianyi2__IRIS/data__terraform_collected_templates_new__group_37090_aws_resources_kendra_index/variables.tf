variable "name" {
  description = "Specifies the name of the Index."
  type        = string
}

variable "role_arn" {
  description = "An AWS Identity and Access Management (IAM) role that gives Amazon Kendra permissions to access your Amazon CloudWatch logs and metrics."
  type        = string
}

variable "description" {
  description = "The description of the Index."
  type        = string
  default     = null
}

variable "edition" {
  description = "The Amazon Kendra edition to use for the index. Valid values: DEVELOPER_EDITION, ENTERPRISE_EDITION, GEN_AI_ENTERPRISE_EDITION."
  type        = string
  default     = "ENTERPRISE_EDITION"

  validation {
    condition     = contains(["DEVELOPER_EDITION", "ENTERPRISE_EDITION", "GEN_AI_ENTERPRISE_EDITION"], var.edition)
    error_message = "resource_aws_kendra_index, edition must be one of: DEVELOPER_EDITION, ENTERPRISE_EDITION, GEN_AI_ENTERPRISE_EDITION."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "user_context_policy" {
  description = "The user context policy. Valid values are ATTRIBUTE_FILTER or USER_TOKEN."
  type        = string
  default     = "ATTRIBUTE_FILTER"

  validation {
    condition     = contains(["ATTRIBUTE_FILTER", "USER_TOKEN"], var.user_context_policy)
    error_message = "resource_aws_kendra_index, user_context_policy must be one of: ATTRIBUTE_FILTER, USER_TOKEN."
  }
}

variable "capacity_units" {
  description = "A block that sets the number of additional document storage and query capacity units that should be used by the index."
  type = object({
    query_capacity_units   = number
    storage_capacity_units = number
  })
  default = null

  validation {
    condition     = var.capacity_units == null || (var.capacity_units.storage_capacity_units >= 0)
    error_message = "resource_aws_kendra_index, capacity_units.storage_capacity_units must be greater than or equal to 0."
  }
}

variable "document_metadata_configuration_updates" {
  description = "One or more blocks that specify the configuration settings for any metadata applied to the documents in the index."
  type = list(object({
    name = string
    type = string
    search = object({
      displayable = bool
      facetable   = bool
      searchable  = bool
      sortable    = bool
    })
    relevance = object({
      importance            = number
      duration              = optional(string)
      freshness             = optional(bool)
      rank_order            = optional(string)
      values_importance_map = optional(map(number))
    })
  }))
  default = []

  validation {
    condition = alltrue([
      for config in var.document_metadata_configuration_updates : (
        length(config.name) >= 1 && length(config.name) <= 30
      )
    ])
    error_message = "resource_aws_kendra_index, document_metadata_configuration_updates.name must be between 1 and 30 characters in length."
  }

  validation {
    condition = alltrue([
      for config in var.document_metadata_configuration_updates : (
        contains(["STRING_VALUE", "STRING_LIST_VALUE", "LONG_VALUE", "DATE_VALUE"], config.type)
      )
    ])
    error_message = "resource_aws_kendra_index, document_metadata_configuration_updates.type must be one of: STRING_VALUE, STRING_LIST_VALUE, LONG_VALUE, DATE_VALUE."
  }

  validation {
    condition = alltrue([
      for config in var.document_metadata_configuration_updates : (
        config.relevance.importance >= 1 && config.relevance.importance <= 10
      )
    ])
    error_message = "resource_aws_kendra_index, document_metadata_configuration_updates.relevance.importance must be between 1 and 10."
  }

  validation {
    condition = alltrue([
      for config in var.document_metadata_configuration_updates : (
        config.type == "DATE_VALUE" ? config.relevance.duration != null : true
      )
    ])
    error_message = "resource_aws_kendra_index, document_metadata_configuration_updates.relevance.duration is required when type is DATE_VALUE."
  }

  validation {
    condition = alltrue([
      for config in var.document_metadata_configuration_updates : (
        config.type == "DATE_VALUE" ? config.relevance.freshness != null : true
      )
    ])
    error_message = "resource_aws_kendra_index, document_metadata_configuration_updates.relevance.freshness is required when type is DATE_VALUE."
  }

  validation {
    condition = alltrue([
      for config in var.document_metadata_configuration_updates : (
        contains(["DATE_VALUE", "LONG_VALUE"], config.type) ? config.relevance.rank_order != null : true
      )
    ])
    error_message = "resource_aws_kendra_index, document_metadata_configuration_updates.relevance.rank_order is required when type is DATE_VALUE or LONG_VALUE."
  }

  validation {
    condition = alltrue([
      for config in var.document_metadata_configuration_updates : (
        config.type == "STRING_VALUE" ? config.relevance.values_importance_map != null : true
      )
    ])
    error_message = "resource_aws_kendra_index, document_metadata_configuration_updates.relevance.values_importance_map is required when type is STRING_VALUE."
  }
}

variable "server_side_encryption_configuration" {
  description = "A block that specifies the identifier of the AWS KMS customer managed key (CMK) that's used to encrypt data indexed by Amazon Kendra."
  type = object({
    kms_key_id = optional(string)
  })
  default = null
}

variable "user_group_resolution_configuration" {
  description = "A block that enables fetching access levels of groups and users from an AWS Single Sign-On identity source."
  type = object({
    user_group_resolution_mode = string
  })
  default = null

  validation {
    condition     = var.user_group_resolution_configuration == null || contains(["AWS_SSO", "NONE"], var.user_group_resolution_configuration.user_group_resolution_mode)
    error_message = "resource_aws_kendra_index, user_group_resolution_configuration.user_group_resolution_mode must be one of: AWS_SSO, NONE."
  }
}

variable "user_token_configurations" {
  description = "A block that specifies the user token configuration."
  type = object({
    json_token_type_configuration = optional(object({
      group_attribute_field     = string
      user_name_attribute_field = string
    }))
    jwt_token_type_configuration = optional(object({
      key_location              = string
      claim_regex               = optional(string)
      group_attribute_field     = optional(string)
      issuer                    = optional(string)
      secrets_manager_arn       = optional(string)
      url                       = optional(string)
      user_name_attribute_field = optional(string)
    }))
  })
  default = null

  validation {
    condition = var.user_token_configurations == null || (
      var.user_token_configurations.json_token_type_configuration == null ||
      (
        length(var.user_token_configurations.json_token_type_configuration.group_attribute_field) >= 1 &&
        length(var.user_token_configurations.json_token_type_configuration.group_attribute_field) <= 2048
      )
    )
    error_message = "resource_aws_kendra_index, user_token_configurations.json_token_type_configuration.group_attribute_field must be between 1 and 2048 characters in length."
  }

  validation {
    condition = var.user_token_configurations == null || (
      var.user_token_configurations.json_token_type_configuration == null ||
      (
        length(var.user_token_configurations.json_token_type_configuration.user_name_attribute_field) >= 1 &&
        length(var.user_token_configurations.json_token_type_configuration.user_name_attribute_field) <= 2048
      )
    )
    error_message = "resource_aws_kendra_index, user_token_configurations.json_token_type_configuration.user_name_attribute_field must be between 1 and 2048 characters in length."
  }

  validation {
    condition = var.user_token_configurations == null || (
      var.user_token_configurations.jwt_token_type_configuration == null ||
      contains(["URL", "SECRET_MANAGER"], var.user_token_configurations.jwt_token_type_configuration.key_location)
    )
    error_message = "resource_aws_kendra_index, user_token_configurations.jwt_token_type_configuration.key_location must be one of: URL, SECRET_MANAGER."
  }

  validation {
    condition = var.user_token_configurations == null || (
      var.user_token_configurations.jwt_token_type_configuration == null ||
      var.user_token_configurations.jwt_token_type_configuration.claim_regex == null ||
      (
        length(var.user_token_configurations.jwt_token_type_configuration.claim_regex) >= 1 &&
        length(var.user_token_configurations.jwt_token_type_configuration.claim_regex) <= 100
      )
    )
    error_message = "resource_aws_kendra_index, user_token_configurations.jwt_token_type_configuration.claim_regex must be between 1 and 100 characters in length."
  }

  validation {
    condition = var.user_token_configurations == null || (
      var.user_token_configurations.jwt_token_type_configuration == null ||
      var.user_token_configurations.jwt_token_type_configuration.group_attribute_field == null ||
      (
        length(var.user_token_configurations.jwt_token_type_configuration.group_attribute_field) >= 1 &&
        length(var.user_token_configurations.jwt_token_type_configuration.group_attribute_field) <= 100
      )
    )
    error_message = "resource_aws_kendra_index, user_token_configurations.jwt_token_type_configuration.group_attribute_field must be between 1 and 100 characters in length."
  }

  validation {
    condition = var.user_token_configurations == null || (
      var.user_token_configurations.jwt_token_type_configuration == null ||
      var.user_token_configurations.jwt_token_type_configuration.issuer == null ||
      (
        length(var.user_token_configurations.jwt_token_type_configuration.issuer) >= 1 &&
        length(var.user_token_configurations.jwt_token_type_configuration.issuer) <= 65
      )
    )
    error_message = "resource_aws_kendra_index, user_token_configurations.jwt_token_type_configuration.issuer must be between 1 and 65 characters in length."
  }

  validation {
    condition = var.user_token_configurations == null || (
      var.user_token_configurations.jwt_token_type_configuration == null ||
      var.user_token_configurations.jwt_token_type_configuration.url == null ||
      can(regex("^(https?|ftp|file):\\/\\/([^\\s]*)$", var.user_token_configurations.jwt_token_type_configuration.url))
    )
    error_message = "resource_aws_kendra_index, user_token_configurations.jwt_token_type_configuration.url must match pattern: ^(https?|ftp|file):\\/\\/([^\\s]*)$."
  }

  validation {
    condition = var.user_token_configurations == null || (
      var.user_token_configurations.jwt_token_type_configuration == null ||
      var.user_token_configurations.jwt_token_type_configuration.user_name_attribute_field == null ||
      (
        length(var.user_token_configurations.jwt_token_type_configuration.user_name_attribute_field) >= 1 &&
        length(var.user_token_configurations.jwt_token_type_configuration.user_name_attribute_field) <= 100
      )
    )
    error_message = "resource_aws_kendra_index, user_token_configurations.jwt_token_type_configuration.user_name_attribute_field must be between 1 and 100 characters in length."
  }
}

variable "tags" {
  description = "Tags to apply to the Index."
  type        = map(string)
  default     = {}
}