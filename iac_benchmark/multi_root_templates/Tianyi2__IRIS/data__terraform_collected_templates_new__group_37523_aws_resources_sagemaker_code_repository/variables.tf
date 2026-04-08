variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "code_repository_name" {
  description = "The name of the Code Repository (must be unique)"
  type        = string

  validation {
    condition     = length(var.code_repository_name) > 0
    error_message = "resource_aws_sagemaker_code_repository, code_repository_name must not be empty."
  }
}

variable "git_config_repository_url" {
  description = "The URL where the Git repository is located"
  type        = string

  validation {
    condition     = length(var.git_config_repository_url) > 0
    error_message = "resource_aws_sagemaker_code_repository, git_config_repository_url must not be empty."
  }

  validation {
    condition     = can(regex("^https?://", var.git_config_repository_url))
    error_message = "resource_aws_sagemaker_code_repository, git_config_repository_url must be a valid HTTP or HTTPS URL."
  }
}

variable "git_config_branch" {
  description = "The default branch for the Git repository"
  type        = string
  default     = null
}

variable "git_config_secret_arn" {
  description = "The Amazon Resource Name (ARN) of the AWS Secrets Manager secret that contains the credentials used to access the git repository"
  type        = string
  default     = null

  validation {
    condition     = var.git_config_secret_arn == null || can(regex("^arn:aws:secretsmanager:[a-z0-9-]+:[0-9]{12}:secret:", var.git_config_secret_arn))
    error_message = "resource_aws_sagemaker_code_repository, git_config_secret_arn must be a valid AWS Secrets Manager ARN or null."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}