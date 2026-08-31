variable "environment_name" {
  type = string
  default     = "dev"
}

variable "name" {
  type = string
  default     = "benchmark"
}

variable "role_policy_attachment_arns" {
  default     = []
  description = "ARNs of additional managed policies to attach to the role."
  type        = set(string)
}

variable "role_policy_documents" {
  default     = {}
  description = "Additional IAM policy documents to attach to the role."
  type        = map(string)
}

variable "workspace_name" {
  type    = string
  default = ""
}
