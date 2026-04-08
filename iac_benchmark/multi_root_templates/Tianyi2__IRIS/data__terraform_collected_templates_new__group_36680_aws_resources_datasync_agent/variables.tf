variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the DataSync Agent."
  type        = string

  validation {
    condition     = var.name != null && var.name != ""
    error_message = "resource_aws_datasync_agent, name must be a non-empty string."
  }
}

variable "activation_key" {
  description = "DataSync Agent activation key during resource creation. Conflicts with ip_address."
  type        = string
  default     = null

}

variable "ip_address" {
  description = "DataSync Agent IP address to retrieve activation key during resource creation. Conflicts with activation_key."
  type        = string
  default     = null

}

variable "private_link_endpoint" {
  description = "The IP address of the VPC endpoint the agent should connect to when retrieving an activation key during resource creation. Conflicts with activation_key."
  type        = string
  default     = null

  validation {
    condition     = var.private_link_endpoint == null || (var.private_link_endpoint != null && var.activation_key == null)
    error_message = "resource_aws_datasync_agent, private_link_endpoint conflicts with activation_key."
  }
}

variable "security_group_arns" {
  description = "The ARNs of the security groups used to protect your data transfer task subnets."
  type        = list(string)
  default     = null

  validation {
    condition = var.security_group_arns == null || (
      var.security_group_arns != null &&
      length(var.security_group_arns) > 0 &&
      alltrue([for arn in var.security_group_arns : can(regex("^arn:aws:ec2:", arn))])
    )
    error_message = "resource_aws_datasync_agent, security_group_arns must be a list of valid security group ARNs."
  }
}

variable "subnet_arns" {
  description = "The Amazon Resource Names (ARNs) of the subnets in which DataSync will create elastic network interfaces for each data transfer task."
  type        = list(string)
  default     = null

  validation {
    condition = var.subnet_arns == null || (
      var.subnet_arns != null &&
      length(var.subnet_arns) > 0 &&
      alltrue([for arn in var.subnet_arns : can(regex("^arn:aws:ec2:", arn))])
    )
    error_message = "resource_aws_datasync_agent, subnet_arns must be a list of valid subnet ARNs."
  }
}

variable "tags" {
  description = "Key-value pairs of resource tags to assign to the DataSync Agent."
  type        = map(string)
  default     = {}
}

variable "vpc_endpoint_id" {
  description = "The ID of the VPC (virtual private cloud) endpoint that the agent has access to."
  type        = string
  default     = null

  validation {
    condition     = var.vpc_endpoint_id == null || can(regex("^vpce-", var.vpc_endpoint_id))
    error_message = "resource_aws_datasync_agent, vpc_endpoint_id must be a valid VPC endpoint ID starting with 'vpce-'."
  }
}

variable "timeouts_create" {
  description = "How long to wait for the DataSync Agent to be created."
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_datasync_agent, timeouts_create must be a valid duration (e.g., '10m', '1h', '30s')."
  }
}