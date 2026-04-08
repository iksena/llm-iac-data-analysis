variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_vpclattice_resource_policy, region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "resource_arn" {
  description = "The ID or Amazon Resource Name (ARN) of the service network or service for which the policy is created."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:vpc-lattice:[a-z0-9-]*:[0-9]{12}:(servicenetwork|service)/[a-zA-Z0-9-]+$", var.resource_arn)) || can(regex("^[a-zA-Z0-9-]+$", var.resource_arn))
    error_message = "resource_aws_vpclattice_resource_policy, resource_arn must be a valid VPC Lattice service network or service ARN, or a valid ID."
  }
}

variable "policy" {
  description = "An IAM policy. The policy string in JSON must not contain newlines or blank lines."
  type        = string

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_vpclattice_resource_policy, policy must be valid JSON."
  }

  validation {
    condition     = !can(regex("\\n|^\\s*$", var.policy))
    error_message = "resource_aws_vpclattice_resource_policy, policy must not contain newlines or blank lines."
  }
}