variable "project_name" {
  type = string
}

variable "agent_security_group_ids" {
  description = "A map of CI agent security group ids"
  type = object({
    internet          = string
    service_endpoints = string
  })
}

variable "vpc_config" {
  type = object({
    private_subnet_ids  = list(string),
    private_subnet_arns = list(string),
    vpc_id              = string,
  })
}

variable "docker_required" {
  type = bool
}

variable "project_environment_variables" {
  type    = list(map(string))
  default = []
}

variable "project_assume_roles" {
  type        = map(string)
  description = "map of environment variable to role arn for use within the build"
}

variable "timeout_in_minutes" {
  default = 15
}

variable "environment_compute_type" {
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
  description = "Compute type: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html#environment.types"
}

variable "environment_type" {
  type        = string
  default     = "LINUX_CONTAINER"
  description = "Environment type: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html#environment.types"
}


variable "src_org" {
  type    = string
  default = "hmrc"
}

variable "src_repo" {
  type = string
}

variable "src_branch" {
  type        = string
  default     = null
  description = "Source repository branch"
}

variable "buildspec" {
  type = string
}

variable "codeconnection_arn" {
  type        = string
  description = "The codestar connection ARN."
}

variable "tags" {
  type        = map(string)
  description = "A map of key, value pairs to be added to resources as tags"
  default     = {}
}

variable "transition_to_glacier_days" {
  description = "Number of days after creation to transition to GLACIER storage"
  type        = number
  default     = 7
}

variable "badge_enabled" {
  description = "Generates a publicly-accessible URL for projects build badge"
  type        = bool
  default     = false
}
