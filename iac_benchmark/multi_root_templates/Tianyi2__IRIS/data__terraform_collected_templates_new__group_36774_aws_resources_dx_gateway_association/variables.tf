variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "dx_gateway_id" {
  description = "The ID of the Direct Connect gateway."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.dx_gateway_id))
    error_message = "resource_aws_dx_gateway_association, dx_gateway_id must be a valid Direct Connect Gateway ID format."
  }
}

variable "associated_gateway_id" {
  description = "The ID of the VGW or transit gateway with which to associate the Direct Connect gateway. Used for single account Direct Connect gateway associations."
  type        = string
  default     = null

  validation {
    condition     = var.associated_gateway_id == null ? true : can(regex("^(vgw-[0-9a-f]{8,17}|tgw-[0-9a-f]{8,17})$", var.associated_gateway_id))
    error_message = "resource_aws_dx_gateway_association, associated_gateway_id must be a valid VGW (vgw-*) or Transit Gateway (tgw-*) ID format."
  }
}

variable "associated_gateway_owner_account_id" {
  description = "The ID of the AWS account that owns the VGW or transit gateway with which to associate the Direct Connect gateway. Used for cross-account Direct Connect gateway associations."
  type        = string
  default     = null

  validation {
    condition     = var.associated_gateway_owner_account_id == null ? true : can(regex("^[0-9]{12}$", var.associated_gateway_owner_account_id))
    error_message = "resource_aws_dx_gateway_association, associated_gateway_owner_account_id must be a 12-digit AWS account ID."
  }
}

variable "proposal_id" {
  description = "The ID of the Direct Connect gateway association proposal. Used for cross-account Direct Connect gateway associations."
  type        = string
  default     = null

  validation {
    condition     = var.proposal_id == null ? true : can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.proposal_id))
    error_message = "resource_aws_dx_gateway_association, proposal_id must be a valid UUID format."
  }
}

variable "allowed_prefixes" {
  description = "VPC prefixes (CIDRs) to advertise to the Direct Connect gateway. Defaults to the CIDR block of the VPC associated with the Virtual Gateway. To enable drift detection, must be configured."
  type        = list(string)
  default     = null

  validation {
    condition = var.allowed_prefixes == null ? true : alltrue([
      for prefix in var.allowed_prefixes : can(cidrhost(prefix, 0))
    ])
    error_message = "resource_aws_dx_gateway_association, allowed_prefixes must contain valid CIDR blocks."
  }
}