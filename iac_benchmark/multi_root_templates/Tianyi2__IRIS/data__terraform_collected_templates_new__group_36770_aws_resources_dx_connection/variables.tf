variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "bandwidth" {
  description = "The bandwidth of the connection. Valid values for dedicated connections: 1Gbps, 10Gbps, 100Gbps, and 400Gbps. Valid values for hosted connections: 50Mbps, 100Mbps, 200Mbps, 300Mbps, 400Mbps, 500Mbps, 1Gbps, 2Gbps, 5Gbps, 10Gbps, and 25Gbps. Case sensitive."
  type        = string

  validation {
    condition = contains([
      "50Mbps", "100Mbps", "200Mbps", "300Mbps", "400Mbps", "500Mbps",
      "1Gbps", "2Gbps", "5Gbps", "10Gbps", "25Gbps", "100Gbps", "400Gbps"
    ], var.bandwidth)
    error_message = "resource_aws_dx_connection, bandwidth must be one of: 50Mbps, 100Mbps, 200Mbps, 300Mbps, 400Mbps, 500Mbps, 1Gbps, 2Gbps, 5Gbps, 10Gbps, 25Gbps, 100Gbps, or 400Gbps."
  }
}

variable "encryption_mode" {
  description = "The connection MAC Security (MACsec) encryption mode. MAC Security (MACsec) is only available on dedicated connections. Valid values are no_encrypt, should_encrypt, and must_encrypt."
  type        = string
  default     = null

  validation {
    condition     = var.encryption_mode == null || contains(["no_encrypt", "should_encrypt", "must_encrypt"], var.encryption_mode)
    error_message = "resource_aws_dx_connection, encryption_mode must be one of: no_encrypt, should_encrypt, or must_encrypt."
  }
}

variable "location" {
  description = "The AWS Direct Connect location where the connection is located. Use locationCode."
  type        = string
}

variable "name" {
  description = "The name of the connection."
  type        = string
}

variable "provider_name" {
  description = "The name of the service provider associated with the connection."
  type        = string
  default     = null
}

variable "request_macsec" {
  description = "Boolean value indicating whether you want the connection to support MAC Security (MACsec). MAC Security (MACsec) is only available on dedicated connections. Default value: false."
  type        = bool
  default     = false

  validation {
    condition     = can(var.request_macsec)
    error_message = "resource_aws_dx_connection, request_macsec must be a boolean value."
  }
}

variable "skip_destroy" {
  description = "Set to true if you do not wish the connection to be deleted at destroy time, and instead just removed from the Terraform state."
  type        = bool
  default     = false

  validation {
    condition     = can(var.skip_destroy)
    error_message = "resource_aws_dx_connection, skip_destroy must be a boolean value."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}

  validation {
    condition     = can(var.tags)
    error_message = "resource_aws_dx_connection, tags must be a map of strings."
  }
}