variable "github_team" {
  type        = string
  description = "Team in an organization used to sync users"
  default     = "benchmark-team"
}

variable "iam_group" {
  type        = string
  description = "IAM group to create"
  default     = "benchmark-group"
}

variable "user_prefix" {
  type        = string
  description = "Prefix for IAM users"
  default     = ""
}
