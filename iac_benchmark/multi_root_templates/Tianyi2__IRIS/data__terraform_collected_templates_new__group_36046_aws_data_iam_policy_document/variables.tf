variable "override_policy_documents" {
  description = "List of IAM policy documents that are merged together into the exported document. In merging, statements with non-blank sids will override statements with the same sid from earlier documents in the list. Statements with non-blank sids will also override statements with the same sid from source_policy_documents. Non-overriding statements will be added to the exported document."
  type        = list(string)
  default     = null

  validation {
    condition = var.override_policy_documents == null || alltrue([
      for doc in var.override_policy_documents : can(jsondecode(doc))
    ])
    error_message = "data_aws_iam_policy_document, override_policy_documents must be valid JSON strings."
  }
}

variable "policy_id" {
  description = "ID for the policy document."
  type        = string
  default     = null
}

variable "source_policy_documents" {
  description = "List of IAM policy documents that are merged together into the exported document. Statements defined in source_policy_documents must have unique sids. Statements with the same sid from override_policy_documents will override source statements."
  type        = list(string)
  default     = null

  validation {
    condition = var.source_policy_documents == null || alltrue([
      for doc in var.source_policy_documents : can(jsondecode(doc))
    ])
    error_message = "data_aws_iam_policy_document, source_policy_documents must be valid JSON strings."
  }
}

variable "policy_version" {
  description = "IAM policy document version. Valid values are 2008-10-17 and 2012-10-17. Defaults to 2012-10-17."
  type        = string
  default     = "2012-10-17"

  validation {
    condition     = contains(["2008-10-17", "2012-10-17"], var.policy_version)
    error_message = "data_aws_iam_policy_document, version must be either '2008-10-17' or '2012-10-17'."
  }
}

variable "statements" {
  description = "List of policy statement configurations."
  type = list(object({
    sid           = optional(string)
    effect        = optional(string, "Allow")
    actions       = optional(list(string))
    not_actions   = optional(list(string))
    resources     = optional(list(string))
    not_resources = optional(list(string))
    principals = optional(list(object({
      type        = string
      identifiers = list(string)
    })))
    not_principals = optional(list(object({
      type        = string
      identifiers = list(string)
    })))
    conditions = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })))
  }))
  default = []

  validation {
    condition = alltrue([
      for stmt in var.statements : stmt.effect == null || contains(["Allow", "Deny"], stmt.effect)
    ])
    error_message = "data_aws_iam_policy_document, statements effect must be either 'Allow' or 'Deny'."
  }

  validation {
    condition = alltrue([
      for stmt in var.statements : !(stmt.resources != null && stmt.not_resources != null)
    ])
    error_message = "data_aws_iam_policy_document, statements cannot have both 'resources' and 'not_resources' specified."
  }

  validation {
    condition = alltrue([
      for stmt in var.statements : stmt.principals == null || alltrue([
        for principal in stmt.principals : contains(["AWS", "Service", "Federated", "CanonicalUser", "*"], principal.type)
      ])
    ])
    error_message = "data_aws_iam_policy_document, statements principals type must be one of: 'AWS', 'Service', 'Federated', 'CanonicalUser', or '*'."
  }

  validation {
    condition = alltrue([
      for stmt in var.statements : stmt.not_principals == null || alltrue([
        for not_principal in stmt.not_principals : contains(["AWS", "Service", "Federated", "CanonicalUser", "*"], not_principal.type)
      ])
    ])
    error_message = "data_aws_iam_policy_document, statements not_principals type must be one of: 'AWS', 'Service', 'Federated', 'CanonicalUser', or '*'."
  }

  validation {
    condition = alltrue([
      for stmt in var.statements : stmt.conditions == null || alltrue([
        for condition in stmt.conditions : condition.test != null && condition.variable != null && condition.values != null
      ])
    ])
    error_message = "data_aws_iam_policy_document, statements conditions must have 'test', 'variable', and 'values' specified."
  }
}