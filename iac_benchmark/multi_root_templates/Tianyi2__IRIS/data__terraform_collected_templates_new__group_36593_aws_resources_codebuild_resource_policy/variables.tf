variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "resource_arn" {
  description = "The ARN of the Project or ReportGroup resource you want to associate with a resource policy."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:codebuild:", var.resource_arn))
    error_message = "resource_aws_codebuild_resource_policy, resource_arn must be a valid CodeBuild ARN starting with 'arn:aws:codebuild:'."
  }
}

variable "policy" {
  description = "A JSON-formatted resource policy. For more information, see Sharing a Project and Sharing a Report Group."
  type        = string

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_codebuild_resource_policy, policy must be valid JSON."
  }
}