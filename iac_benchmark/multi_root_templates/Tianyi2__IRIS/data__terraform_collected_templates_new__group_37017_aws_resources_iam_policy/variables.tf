variable "description" {
  description = "Description of the IAM policy"
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the policy. If omitted, Terraform will assign a random, unique name"
  type        = string
  default     = null

  validation {
    condition     = var.name == null || var.name_prefix == null
    error_message = "resource_aws_iam_policy, name: Conflicts with name_prefix. Only one of name or name_prefix can be specified."
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name"
  type        = string
  default     = null
}

variable "path" {
  description = "Path in which to create the policy"
  type        = string
  default     = "/"

  validation {
    condition     = can(regex("^/.*/$", var.path)) || var.path == "/"
    error_message = "resource_aws_iam_policy, path: Must be a valid IAM path starting and ending with forward slash."
  }
}

variable "policy" {
  description = "Policy document. This is a JSON formatted string"
  type        = string

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_iam_policy, policy: Must be valid JSON."
  }
}

variable "tags" {
  description = "Map of resource tags for the IAM Policy"
  type        = map(string)
  default     = {}
}