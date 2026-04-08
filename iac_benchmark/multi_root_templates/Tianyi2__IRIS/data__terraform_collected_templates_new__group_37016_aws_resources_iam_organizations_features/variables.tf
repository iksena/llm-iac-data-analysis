variable "enabled_features" {
  description = "List of IAM features to enable. Valid values are RootCredentialsManagement and RootSessions."
  type        = list(string)

  validation {
    condition = alltrue([
      for feature in var.enabled_features : contains(["RootCredentialsManagement", "RootSessions"], feature)
    ])
    error_message = "resource_aws_iam_organizations_features, enabled_features must only contain 'RootCredentialsManagement' and 'RootSessions'."
  }

  validation {
    condition     = length(var.enabled_features) > 0
    error_message = "resource_aws_iam_organizations_features, enabled_features must contain at least one feature."
  }
}