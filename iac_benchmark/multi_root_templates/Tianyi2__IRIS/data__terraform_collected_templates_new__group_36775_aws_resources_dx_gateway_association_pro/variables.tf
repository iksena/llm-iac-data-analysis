variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "associated_gateway_id" {
  description = "The ID of the VGW or transit gateway with which to associate the Direct Connect gateway."
  type        = string

  validation {
    condition     = can(regex("^(vgw-|tgw-)", var.associated_gateway_id))
    error_message = "resource_aws_dx_gateway_association_proposal, associated_gateway_id must start with 'vgw-' for Virtual Private Gateway or 'tgw-' for Transit Gateway."
  }
}

variable "dx_gateway_id" {
  description = "Direct Connect Gateway identifier."
  type        = string

  validation {
    condition     = can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.dx_gateway_id))
    error_message = "resource_aws_dx_gateway_association_proposal, dx_gateway_id must be a valid UUID format."
  }
}

variable "dx_gateway_owner_account_id" {
  description = "AWS Account identifier of the Direct Connect Gateway's owner."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.dx_gateway_owner_account_id))
    error_message = "resource_aws_dx_gateway_association_proposal, dx_gateway_owner_account_id must be a 12-digit AWS account ID."
  }
}

variable "allowed_prefixes" {
  description = "VPC prefixes (CIDRs) to advertise to the Direct Connect gateway. Defaults to the CIDR block of the VPC associated with the Virtual Gateway."
  type        = set(string)
  default     = null

  validation {
    condition = var.allowed_prefixes == null ? true : alltrue([
      for prefix in var.allowed_prefixes : can(cidrhost(prefix, 0))
    ])
    error_message = "resource_aws_dx_gateway_association_proposal, allowed_prefixes must contain valid CIDR blocks."
  }
}