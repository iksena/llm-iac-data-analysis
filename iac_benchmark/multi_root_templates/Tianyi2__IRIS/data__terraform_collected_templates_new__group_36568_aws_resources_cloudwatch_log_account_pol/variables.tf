variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "policy_document" {
  description = "Text of the account policy."
  type        = string

  validation {
    condition     = length(var.policy_document) > 0
    error_message = "resource_aws_cloudwatch_log_account_policy, policy_document must not be empty."
  }
}

variable "policy_type" {
  description = "Type of account policy. One of DATA_PROTECTION_POLICY, SUBSCRIPTION_FILTER_POLICY, FIELD_INDEX_POLICY or TRANSFORMER_POLICY."
  type        = string

  validation {
    condition = contains([
      "DATA_PROTECTION_POLICY",
      "SUBSCRIPTION_FILTER_POLICY",
      "FIELD_INDEX_POLICY",
      "TRANSFORMER_POLICY"
    ], var.policy_type)
    error_message = "resource_aws_cloudwatch_log_account_policy, policy_type must be one of: DATA_PROTECTION_POLICY, SUBSCRIPTION_FILTER_POLICY, FIELD_INDEX_POLICY, TRANSFORMER_POLICY."
  }
}

variable "policy_name" {
  description = "Name of the account policy."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "resource_aws_cloudwatch_log_account_policy, policy_name must not be empty."
  }
}

variable "scope" {
  description = "Currently defaults to and only accepts the value: ALL."
  type        = string
  default     = "ALL"

  validation {
    condition     = var.scope == "ALL"
    error_message = "resource_aws_cloudwatch_log_account_policy, scope must be 'ALL'."
  }
}

variable "selection_criteria" {
  description = "Criteria for applying a subscription filter policy to a selection of log groups. The only allowable criteria selector is LogGroupName NOT IN []."
  type        = string
  default     = null
}