variable "auth_mode" {
  description = "Specifies whether the Studio authenticates users using IAM or Amazon Web Services SSO"
  type        = string

  validation {
    condition     = contains(["SSO", "IAM"], var.auth_mode)
    error_message = "resource_aws_emr_studio, auth_mode must be either 'SSO' or 'IAM'."
  }
}

variable "default_s3_location" {
  description = "The Amazon S3 location to back up Amazon EMR Studio Workspaces and notebook files"
  type        = string

  validation {
    condition     = can(regex("^s3://", var.default_s3_location))
    error_message = "resource_aws_emr_studio, default_s3_location must be a valid S3 URI starting with 's3://'."
  }
}

variable "engine_security_group_id" {
  description = "The ID of the Amazon EMR Studio Engine security group"
  type        = string

  validation {
    condition     = can(regex("^sg-[0-9a-f]{8,17}$", var.engine_security_group_id))
    error_message = "resource_aws_emr_studio, engine_security_group_id must be a valid security group ID."
  }
}

variable "name" {
  description = "A descriptive name for the Amazon EMR Studio"
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 256
    error_message = "resource_aws_emr_studio, name must be between 1 and 256 characters."
  }
}

variable "service_role" {
  description = "The IAM role that the Amazon EMR Studio assumes"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::", var.service_role))
    error_message = "resource_aws_emr_studio, service_role must be a valid IAM role ARN."
  }
}

variable "subnet_ids" {
  description = "A list of subnet IDs to associate with the Amazon EMR Studio"
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) > 0 && length(var.subnet_ids) <= 5
    error_message = "resource_aws_emr_studio, subnet_ids must contain between 1 and 5 subnet IDs."
  }

  validation {
    condition     = alltrue([for id in var.subnet_ids : can(regex("^subnet-[0-9a-f]{8,17}$", id))])
    error_message = "resource_aws_emr_studio, subnet_ids must contain valid subnet IDs."
  }
}

variable "vpc_id" {
  description = "The ID of the Amazon Virtual Private Cloud (Amazon VPC) to associate with the Studio"
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]{8,17}$", var.vpc_id))
    error_message = "resource_aws_emr_studio, vpc_id must be a valid VPC ID."
  }
}

variable "workspace_security_group_id" {
  description = "The ID of the Amazon EMR Studio Workspace security group"
  type        = string

  validation {
    condition     = can(regex("^sg-[0-9a-f]{8,17}$", var.workspace_security_group_id))
    error_message = "resource_aws_emr_studio, workspace_security_group_id must be a valid security group ID."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "description" {
  description = "A detailed description of the Amazon EMR Studio"
  type        = string
  default     = null
}

variable "encryption_key_arn" {
  description = "The AWS KMS key identifier (ARN) used to encrypt Amazon EMR Studio workspace and notebook files"
  type        = string
  default     = null

  validation {
    condition     = var.encryption_key_arn == null || can(regex("^arn:aws:kms:", var.encryption_key_arn))
    error_message = "resource_aws_emr_studio, encryption_key_arn must be a valid KMS key ARN."
  }
}

variable "idp_auth_url" {
  description = "The authentication endpoint of your identity provider (IdP)"
  type        = string
  default     = null

  validation {
    condition     = var.idp_auth_url == null || can(regex("^https://", var.idp_auth_url))
    error_message = "resource_aws_emr_studio, idp_auth_url must be a valid HTTPS URL."
  }
}

variable "idp_relay_state_parameter_name" {
  description = "The name that your identity provider (IdP) uses for its RelayState parameter"
  type        = string
  default     = null
}

variable "tags" {
  description = "List of tags to apply to the EMR Studio"
  type        = map(string)
  default     = {}
}

variable "user_role" {
  description = "The IAM user role that users and groups assume when logged in to an Amazon EMR Studio"
  type        = string
  default     = null

  validation {
    condition     = var.user_role == null || can(regex("^arn:aws:iam::", var.user_role))
    error_message = "resource_aws_emr_studio, user_role must be a valid IAM role ARN."
  }
}