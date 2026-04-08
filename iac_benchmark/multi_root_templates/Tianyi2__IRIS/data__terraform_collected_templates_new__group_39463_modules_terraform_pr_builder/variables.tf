variable "accounts" {
  type = any
}

variable "assumable_roles" {
  type        = list(string)
  description = "Map of environment variable to role arn for use within the build"
}

variable "build_timeout" {
  type        = number
  description = "The build timeout in minutes"
  default     = 30
}

variable "codeconnection_arn" {
  type        = string
  description = "The codestar connection ARN."
}

variable "concurrent_build_limit" {
  type    = number
  default = 3
}

variable "environments" {
  type    = list(string)
  default = []
}

variable "environment_compute_type" {
  type    = string
  default = "BUILD_GENERAL1_SMALL"

}

variable "environment_image" {
  type    = string
  default = "aws/codebuild/standard:7.0"
}

variable "environment_type" {
  type    = string
  default = "LINUX_CONTAINER"
}

variable "environment_image_pull_credentials_type" {
  type    = string
  default = "CODEBUILD"
}

variable "environment_variables" {
  type    = list(map(string))
  default = []
}

variable "queued_timeout" {
  type    = number
  default = 30
}

variable "src_branch" {
  type        = string
  default     = null
  description = "Source repository branch"
}

variable "src_org" {
  type    = string
  default = "hmrc"
}

variable "src_repo" {
  type = string
}

variable "src_type" {
  type        = string
  description = "The source type, can be either 'CODEPIPELINE' or 'GITHUB'"
  default     = "GITHUB"
}

variable "tags" {
  type        = map(string)
  description = "A map of key, value pairs to be added to resources as tags"
  default     = {}
}

variable "vpc_config_security_group_ids" {
  description = "A list of security group IDs for the VPC configuration"
  type        = list(string)
}

variable "vpc_config_subnets" {
  description = "A list of subnet IDs for the VPC configuration"
  type        = list(string)
}

variable "vpc_config_vpc_id" {
  description = "The VPC ID for the VPC configuration"
  type        = string
}