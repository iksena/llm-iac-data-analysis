variable "content" {
  description = "The policy content to add to the new policy. For example, if you create a service control policy (SCP), this string must be JSON text that specifies the permissions that admins in attached accounts can delegate to their users, groups, and roles."
  type        = string

  validation {
    condition     = length(var.content) > 0
    error_message = "resource_aws_organizations_policy, content must not be empty."
  }
}

variable "name" {
  description = "The friendly name to assign to the policy."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_organizations_policy, name must not be empty."
  }
}

variable "description" {
  description = "A description to assign to the policy."
  type        = string
  default     = null
}

variable "skip_destroy" {
  description = "If set to true, destroy will not delete the policy and instead just remove the resource from state. This can be useful in situations where the policies (and the associated attachment) must be preserved to meet the AWS minimum requirement of 1 attached policy."
  type        = bool
  default     = false
}

variable "type" {
  description = "The type of policy to create. Valid values are AISERVICES_OPT_OUT_POLICY, BACKUP_POLICY, RESOURCE_CONTROL_POLICY (RCP), SERVICE_CONTROL_POLICY (SCP), and TAG_POLICY."
  type        = string
  default     = "SERVICE_CONTROL_POLICY"

  validation {
    condition = contains([
      "AISERVICES_OPT_OUT_POLICY",
      "BACKUP_POLICY",
      "RESOURCE_CONTROL_POLICY",
      "SERVICE_CONTROL_POLICY",
      "TAG_POLICY"
    ], var.type)
    error_message = "resource_aws_organizations_policy, type must be one of: AISERVICES_OPT_OUT_POLICY, BACKUP_POLICY, RESOURCE_CONTROL_POLICY, SERVICE_CONTROL_POLICY, TAG_POLICY."
  }
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}