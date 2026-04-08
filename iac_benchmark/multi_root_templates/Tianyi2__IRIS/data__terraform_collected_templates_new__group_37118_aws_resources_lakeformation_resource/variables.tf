variable "arn" {
  description = "Amazon Resource Name (ARN) of the resource"
  type        = string

  validation {
    condition     = can(regex("^arn:aws", var.arn))
    error_message = "resource_aws_lakeformation_resource, arn must be a valid ARN starting with 'arn:aws'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_lakeformation_resource, region must be a valid AWS region format or null."
  }
}

variable "role_arn" {
  description = "Role that has read/write access to the resource"
  type        = string
  default     = null

  validation {
    condition     = var.role_arn == null || can(regex("^arn:aws:iam::", var.role_arn))
    error_message = "resource_aws_lakeformation_resource, role_arn must be a valid IAM role ARN starting with 'arn:aws:iam::' or null."
  }
}

variable "use_service_linked_role" {
  description = "Designates an AWS Identity and Access Management (IAM) service-linked role by registering this role with the Data Catalog"
  type        = bool
  default     = null
}

variable "hybrid_access_enabled" {
  description = "Flag to enable AWS LakeFormation hybrid access permission mode"
  type        = bool
  default     = null
}

variable "with_federation" {
  description = "Whether or not the resource is a federated resource. Set to true when registering AWS Glue connections for federated catalog functionality"
  type        = bool
  default     = null
}

variable "with_privileged_access" {
  description = "Boolean to grant the calling principal the permissions to perform all supported Lake Formation operations on the registered data location"
  type        = bool
  default     = null
}