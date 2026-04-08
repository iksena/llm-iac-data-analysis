variable "pipeline_name" {
  type    = string
  default = "platsec-terraform-pipeline"
  validation {
    condition     = can(regex("^[0-9a-z-]+$", var.pipeline_name))
    error_message = "Due to resource name limitations only lowercase alphanumeric characters and hyphens are allowed in pipeline names."
  }
}

variable "src_org" {
  type    = string
  default = "hmrc"
}

variable "src_repo" {
  type    = string
  default = "platsec-terraform"
}

variable "branch" {
  type    = string
  default = "main"
}

variable "sns_topic_arn" {
  type    = string
  default = null
}

variable "sns_kms_key_arn" {
  type    = string
  default = null
}

variable "test_timeout_in_minutes" {
  default = 15
}

variable "step_assume_roles" {
  type = list(map(map(string)))
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

variable "admin_roles" {
  type        = list(string)
  description = "A list of roles to allow admin access to bucket"
  default     = []
}

variable "access_log_bucket_id" {
  type = string
}

variable "github_token" {
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
