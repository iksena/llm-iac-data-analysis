variable "step_name" {
  type = string
}

variable "vpc_config" {
  type = object({
    private_subnet_ids  = list(string),
    private_subnet_arns = list(string),
    vpc_id              = string,
  })
}

variable "agent_security_group_ids" {
  type = list(string)
}

variable "docker_required" {
  type = bool
}

variable "s3_bucket_arn" {
  type = string
  validation {
    condition     = can(regex("^arn:aws:s3:", var.s3_bucket_arn))
    error_message = "Arn must be given and should start with 'arn:aws:s3:'."
  }
}

variable "policy_arns" {
  type = list(string)
}

variable "step_environment_variables" {
  type    = list(map(string))
  default = []
}

variable "step_assume_roles" {
  type        = map(string)
  default     = {}
  description = "map of environment variable to role arn for use within the build"
}

variable "timeout_in_minutes" {
  default = 10
}

variable "tags" {
  type        = map(string)
  description = "A map of key, value pairs to be added to resources as tags"
  default     = {}
}