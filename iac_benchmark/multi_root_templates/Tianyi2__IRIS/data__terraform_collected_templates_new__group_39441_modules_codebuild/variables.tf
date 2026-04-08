variable "name" {
  type        = string
  description = "The name of the codebuild project"
}

variable "description" {
  type        = string
  description = "The description of the codebuild project"
  default     = ""
}

variable "buildspec" {
  type = string
}

variable "build_timeout" {
  type        = number
  description = "The build timeout in minutes"
  default     = 30
}

variable "build_type" {
  type        = string
  description = "The type of build, can be either 'terraform', or 'container'"
}

variable "build_action" {
  type        = string
  description = "The build action, can be either 'plan', 'apply', or 'build'"
  default     = "plan"
}

variable "codeconnection_arn" {
  type        = string
  description = "The codestar connection ARN."
}

variable "concurrent_build_limit" {
  type    = number
  default = 3
}

variable "encryption_key" {
  type        = string
  description = "The AWS KMS Key assigned to the artifact store targeted by build outputs"
  default     = null
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

variable "is_ci" {
  type        = bool
  description = "Defined if the project is a CI job to enable integration with GitHub pull requests"
  default     = false
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