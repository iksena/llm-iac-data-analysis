variable "name" {
  description = "The name of the connection"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_dx_gateway, name must not be empty."
  }
}

variable "amazon_side_asn" {
  description = "The ASN to be configured on the Amazon side of the connection. The ASN must be in the private range of 64,512 to 65,534 or 4,200,000,000 to 4,294,967,294"
  type        = string

  validation {
    condition     = can(regex("^(6[4-5][0-9]{3}|6553[0-4]|4[0-2][0-9]{8}|429[0-4][0-9]{6}|4294[0-8][0-9]{5}|42949[0-5][0-9]{4}|429496[0-6][0-9]{3}|4294967[0-1][0-9]{2}|42949672[0-8][0-9]|429496729[0-4])$", var.amazon_side_asn)) || (tonumber(var.amazon_side_asn) >= 64512 && tonumber(var.amazon_side_asn) <= 65534) || (tonumber(var.amazon_side_asn) >= 4200000000 && tonumber(var.amazon_side_asn) <= 4294967294)
    error_message = "resource_aws_dx_gateway, amazon_side_asn must be in the private range of 64,512 to 65,534 or 4,200,000,000 to 4,294,967,294."
  }
}

variable "create_timeout" {
  description = "Timeout for creating the Direct Connect Gateway"
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.create_timeout))
    error_message = "resource_aws_dx_gateway, create_timeout must be a valid duration (e.g., 10m, 1h, 30s)."
  }
}

variable "delete_timeout" {
  description = "Timeout for deleting the Direct Connect Gateway"
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.delete_timeout))
    error_message = "resource_aws_dx_gateway, delete_timeout must be a valid duration (e.g., 10m, 1h, 30s)."
  }
}