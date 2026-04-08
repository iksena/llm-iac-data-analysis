variable "project_id" {
  description = "The project ID to create the workload identity pool in."
  type        = string
}

variable "grants" {
  description = "The list of IAM roles to grant to the workload identity pool."
  type        = list(string)
}

variable "repo_full_name" {
  description = "The full name of the repository to grant access to (org/repo-name)."
  type        = string
}