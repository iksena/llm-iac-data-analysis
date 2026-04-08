variable "pipeline" {
  type = string
}

variable "src_org" {
  type    = string
  default = "hmrc"
}

variable "src_repo" {
  type = string
}

variable "github_token" {
  type = string
}

variable "vpc_config" {
  type = object({
    private_subnet_ids  = list(string),
    private_subnet_arns = list(string),
    vpc_id              = string,
  })
}

variable "sns_topic_arn" {
  type    = string
  default = null
}

variable "sns_kms_key_arn" {
  type    = string
  default = null
}

variable "access_log_bucket_id" {
  description = "The name of the access log bucket"
  type        = string
}

variable "admin_roles" {
  type        = list(string)
  description = "A list of roles to allow admin access to bucket"
  default     = []
}

###
# Presume a codeconnection is present to simplify the config for now
###
variable "codeconnection_arn" {
  type        = string
  description = "(Optional) The aws_codestarconnections_connection ARN."
  default     = ""
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
