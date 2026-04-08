variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cluster_identifier" {
  description = "The cluster identifier of the cluster to access."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.cluster_identifier)) && length(var.cluster_identifier) >= 1 && length(var.cluster_identifier) <= 63
    error_message = "resource_aws_redshift_endpoint_access, cluster_identifier must be 1-63 characters long and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "endpoint_name" {
  description = "The Redshift-managed VPC endpoint name."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.endpoint_name)) && length(var.endpoint_name) >= 1 && length(var.endpoint_name) <= 30
    error_message = "resource_aws_redshift_endpoint_access, endpoint_name must be 1-30 characters long and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "resource_owner" {
  description = "The Amazon Web Services account ID of the owner of the cluster. This is only required if the cluster is in another Amazon Web Services account."
  type        = string
  default     = null

  validation {
    condition     = var.resource_owner == null || can(regex("^\\d{12}$", var.resource_owner))
    error_message = "resource_aws_redshift_endpoint_access, resource_owner must be a 12-digit AWS account ID."
  }
}

variable "subnet_group_name" {
  description = "The subnet group from which Amazon Redshift chooses the subnet to deploy the endpoint."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.subnet_group_name)) && length(var.subnet_group_name) >= 1 && length(var.subnet_group_name) <= 255
    error_message = "resource_aws_redshift_endpoint_access, subnet_group_name must be 1-255 characters long and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "vpc_security_group_ids" {
  description = "The security group that defines the ports, protocols, and sources for inbound traffic that you are authorizing into your endpoint."
  type        = list(string)
  default     = null

  validation {
    condition     = var.vpc_security_group_ids == null || alltrue([for sg in var.vpc_security_group_ids : can(regex("^sg-[0-9a-f]+$", sg))])
    error_message = "resource_aws_redshift_endpoint_access, vpc_security_group_ids must be a list of valid security group IDs starting with 'sg-'."
  }
}