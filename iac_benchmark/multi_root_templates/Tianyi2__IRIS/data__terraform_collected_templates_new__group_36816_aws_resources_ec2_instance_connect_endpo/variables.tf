variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_ec2_instance_connect_endpoint, region must be a valid AWS region format."
  }
}

variable "preserve_client_ip" {
  description = "Indicates whether your client's IP address is preserved as the source."
  type        = bool
  default     = true

  validation {
    condition     = can(tobool(var.preserve_client_ip))
    error_message = "resource_aws_ec2_instance_connect_endpoint, preserve_client_ip must be a boolean value."
  }
}

variable "security_group_ids" {
  description = "One or more security groups to associate with the endpoint. If you don't specify a security group, the default security group for the VPC will be associated with the endpoint."
  type        = list(string)
  default     = null

  validation {
    condition     = var.security_group_ids == null || (length(var.security_group_ids) > 0 && alltrue([for sg_id in var.security_group_ids : can(regex("^sg-[a-z0-9]{8,17}$", sg_id))]))
    error_message = "resource_aws_ec2_instance_connect_endpoint, security_group_ids must be a list of valid security group IDs (sg-xxxxxxxx format)."
  }
}

variable "subnet_id" {
  description = "The ID of the subnet in which to create the EC2 Instance Connect Endpoint."
  type        = string

  validation {
    condition     = can(regex("^subnet-[a-z0-9]{8,17}$", var.subnet_id))
    error_message = "resource_aws_ec2_instance_connect_endpoint, subnet_id must be a valid subnet ID (subnet-xxxxxxxx format)."
  }
}

variable "tags" {
  description = "Map of tags to assign to this resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}

  validation {
    condition     = can(tomap(var.tags))
    error_message = "resource_aws_ec2_instance_connect_endpoint, tags must be a map of string values."
  }
}