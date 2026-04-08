variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "internet_gateway_id" {
  description = "The ID of the internet gateway."
  type        = string

  validation {
    condition     = can(regex("^igw-[0-9a-f]+$", var.internet_gateway_id))
    error_message = "resource_aws_internet_gateway_attachment, internet_gateway_id must be a valid Internet Gateway ID (starts with 'igw-')."
  }
}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]+$", var.vpc_id))
    error_message = "resource_aws_internet_gateway_attachment, vpc_id must be a valid VPC ID (starts with 'vpc-')."
  }
}