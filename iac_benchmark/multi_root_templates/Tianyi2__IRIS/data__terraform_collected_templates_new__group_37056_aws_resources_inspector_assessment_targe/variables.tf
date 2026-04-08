variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_inspector_assessment_target, region must be a valid AWS region format."
  }
}

variable "name" {
  description = "The name of the assessment target."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 140
    error_message = "resource_aws_inspector_assessment_target, name must be between 1 and 140 characters."
  }
}

variable "resource_group_arn" {
  description = "Inspector Resource Group Amazon Resource Name (ARN) stating tags for instance matching. If not specified, all EC2 instances in the current AWS account and region are included in the assessment target."
  type        = string
  default     = null

  validation {
    condition     = var.resource_group_arn == null || can(regex("^arn:aws:inspector:[a-z0-9-]+:[0-9]{12}:resourcegroup/.+$", var.resource_group_arn))
    error_message = "resource_aws_inspector_assessment_target, resource_group_arn must be a valid Inspector Resource Group ARN format."
  }
}