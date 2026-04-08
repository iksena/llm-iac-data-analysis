variable "tags" {
  description = "Tags to assign"
  type        = map(string)
  default     = {}
}

variable "repo_name" {
  description = "The full name of the Github Repo that should be allowed to assume the role. E.g. UKHSA-Internal/devops-terraform-example-project"
  type        = string

  validation {
    condition     = var.repo_name != "*"
    error_message = "The repo_name variable must not be a wildcard"
  }
}

variable "allowed_refs" {
  description = <<EOF
      The 'audience' that should be allowed to assume the role. Use '*' for all branches / enviroments. 
      By default, only the 'main' branch can assume the role.

      For more examples on how to filter by branch, environment, tag or event type see:
      https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/about-security-hardening-with-openid-connect#example-subject-claims
    EOF
  type        = string
}

variable "iam_policy_arn" {
  description = "The ARN of the IAM policy that the OIDC role should use. Will use a default policy if not specified."
  type        = string
  default     = ""
}

variable "additional_allowed_repos" {
  description = "A map of additional Github repos and their subjects that can assume the AWS role"
  type = map(object({
    sub = string
  }))
  default = {}
}
