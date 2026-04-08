variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "resource_arn" {
  description = "Resource ARN of the resource for which a policy is retrieved."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:vpc-lattice:", var.resource_arn))
    error_message = "data_aws_vpclattice_resource_policy, resource_arn must be a valid VPC Lattice ARN."
  }
}