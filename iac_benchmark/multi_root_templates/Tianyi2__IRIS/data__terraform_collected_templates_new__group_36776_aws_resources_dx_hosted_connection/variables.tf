variable "name" {
  description = "The name of the connection"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_dx_hosted_connection, name must not be empty."
  }
}

variable "bandwidth" {
  description = "The bandwidth of the connection. Valid values for hosted connections: 50Mbps, 100Mbps, 200Mbps, 300Mbps, 400Mbps, 500Mbps, 1Gbps, 2Gbps, 5Gbps, 10Gbps, and 25Gbps"
  type        = string

  validation {
    condition = contains([
      "50Mbps", "100Mbps", "200Mbps", "300Mbps", "400Mbps", "500Mbps",
      "1Gbps", "2Gbps", "5Gbps", "10Gbps", "25Gbps"
    ], var.bandwidth)
    error_message = "resource_aws_dx_hosted_connection, bandwidth must be one of: 50Mbps, 100Mbps, 200Mbps, 300Mbps, 400Mbps, 500Mbps, 1Gbps, 2Gbps, 5Gbps, 10Gbps, 25Gbps."
  }
}

variable "connection_id" {
  description = "The ID of the interconnect or LAG"
  type        = string

  validation {
    condition     = length(var.connection_id) > 0
    error_message = "resource_aws_dx_hosted_connection, connection_id must not be empty."
  }
}

variable "owner_account_id" {
  description = "The ID of the AWS account of the customer for the connection"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.owner_account_id))
    error_message = "resource_aws_dx_hosted_connection, owner_account_id must be a 12-digit AWS account ID."
  }
}

variable "vlan" {
  description = "The dedicated VLAN provisioned to the hosted connection"
  type        = number

  validation {
    condition     = var.vlan >= 1 && var.vlan <= 4094
    error_message = "resource_aws_dx_hosted_connection, vlan must be between 1 and 4094."
  }
}