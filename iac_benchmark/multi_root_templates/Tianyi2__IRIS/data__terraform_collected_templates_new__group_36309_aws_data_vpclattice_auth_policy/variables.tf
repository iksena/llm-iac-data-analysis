variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_vpclattice_auth_policy, region must be a valid AWS region format."
  }
}

variable "resource_identifier" {
  description = "The ID or Amazon Resource Name (ARN) of the service network or service for which the policy is created."
  type        = string

  validation {
    condition     = can(regex("^(arn:aws[a-zA-Z-]*:vpc-lattice:[a-z0-9-]+:[0-9]{12}:(service|servicenetwork)/[a-zA-Z0-9-]+|[a-zA-Z0-9-]+)$", var.resource_identifier))
    error_message = "data_aws_vpclattice_auth_policy, resource_identifier must be a valid service or service network ID or ARN."
  }
}