variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "authentication" {
  description = "The authentication type for the client VPC connection. Specify one of these auth type strings: SASL_IAM, SASL_SCRAM, or TLS."
  type        = string

  validation {
    condition     = contains(["SASL_IAM", "SASL_SCRAM", "TLS"], var.authentication)
    error_message = "resource_aws_msk_vpc_connection, authentication must be one of: SASL_IAM, SASL_SCRAM, or TLS."
  }
}

variable "client_subnets" {
  description = "The list of subnets in the client VPC to connect to."
  type        = list(string)

  validation {
    condition     = length(var.client_subnets) > 0
    error_message = "resource_aws_msk_vpc_connection, client_subnets must contain at least one subnet."
  }
}

variable "security_groups" {
  description = "The security groups to attach to the ENIs for the broker nodes."
  type        = list(string)

  validation {
    condition     = length(var.security_groups) > 0
    error_message = "resource_aws_msk_vpc_connection, security_groups must contain at least one security group."
  }
}

variable "target_cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kafka:", var.target_cluster_arn))
    error_message = "resource_aws_msk_vpc_connection, target_cluster_arn must be a valid MSK cluster ARN starting with 'arn:aws:kafka:'."
  }
}

variable "vpc_id" {
  description = "The VPC ID of the remote client."
  type        = string

  validation {
    condition     = can(regex("^vpc-", var.vpc_id))
    error_message = "resource_aws_msk_vpc_connection, vpc_id must be a valid VPC ID starting with 'vpc-'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "timeout_create" {
  description = "Timeout for creating the MSK VPC connection."
  type        = string
  default     = "60m"
}

variable "timeout_update" {
  description = "Timeout for updating the MSK VPC connection."
  type        = string
  default     = "180m"
}

variable "timeout_delete" {
  description = "Timeout for deleting the MSK VPC connection."
  type        = string
  default     = "90m"
}