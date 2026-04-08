variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_vpc_endpoint_subnet_association, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "vpc_endpoint_id" {
  description = "The ID of the VPC endpoint with which the subnet will be associated."
  type        = string

  validation {
    condition     = can(regex("^vpce-[a-zA-Z0-9]{8,17}$", var.vpc_endpoint_id))
    error_message = "resource_aws_vpc_endpoint_subnet_association, vpc_endpoint_id must be a valid VPC endpoint ID starting with 'vpce-'."
  }
}

variable "subnet_id" {
  description = "The ID of the subnet to be associated with the VPC endpoint."
  type        = string

  validation {
    condition     = can(regex("^subnet-[a-zA-Z0-9]{8,17}$", var.subnet_id))
    error_message = "resource_aws_vpc_endpoint_subnet_association, subnet_id must be a valid subnet ID starting with 'subnet-'."
  }
}

variable "timeouts_create" {
  description = "Timeout for creating the VPC endpoint subnet association."
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_vpc_endpoint_subnet_association, timeouts_create must be a valid duration format (e.g., '10m', '1h', '30s')."
  }
}

variable "timeouts_delete" {
  description = "Timeout for deleting the VPC endpoint subnet association."
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_delete))
    error_message = "resource_aws_vpc_endpoint_subnet_association, timeouts_delete must be a valid duration format (e.g., '10m', '1h', '30s')."
  }
}