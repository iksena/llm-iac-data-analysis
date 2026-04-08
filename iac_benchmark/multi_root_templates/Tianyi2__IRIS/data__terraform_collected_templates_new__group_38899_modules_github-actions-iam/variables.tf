variable "repository_scope" {
  description = "The scope the role is active for. Leave as `org/repo:*` for anything in the repo."
  type        = list(string)

  validation {
    condition = alltrue([
      for scope in var.repository_scope : startswith(scope, "repo:dotkom/")
    ])
    error_message = "Do not give cross-organization access to any IAM role."
  }
}

variable "role_name" {
  description = "The name of the role to create."
  type        = string
}
