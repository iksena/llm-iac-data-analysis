variable "endpoint_name" {
  description = "The name of the endpoint"
  type        = string

  validation {
    condition     = length(var.endpoint_name) > 0
    error_message = "resource_aws_redshiftserverless_endpoint_access, endpoint_name must not be empty."
  }
}

variable "workgroup_name" {
  description = "The name of the workgroup"
  type        = string

  validation {
    condition     = length(var.workgroup_name) > 0
    error_message = "resource_aws_redshiftserverless_endpoint_access, workgroup_name must not be empty."
  }
}

variable "subnet_ids" {
  description = "An array of VPC subnet IDs to associate with the endpoint"
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "resource_aws_redshiftserverless_endpoint_access, subnet_ids must contain at least one subnet ID."
  }
}

variable "owner_account" {
  description = "The owner Amazon Web Services account for the Amazon Redshift Serverless workgroup"
  type        = string
  default     = null

  validation {
    condition     = var.owner_account == null || can(regex("^[0-9]{12}$", var.owner_account))
    error_message = "resource_aws_redshiftserverless_endpoint_access, owner_account must be a valid 12-digit AWS account ID when specified."
  }
}

variable "vpc_security_group_ids" {
  description = "An array of security group IDs to associate with the workgroup"
  type        = list(string)
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}