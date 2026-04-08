variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$|^[a-z]{2}-[a-z]+-[0-9][a-z]$", var.region))
    error_message = "resource_aws_ram_principal_association, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "principal" {
  description = "The principal to associate with the resource share. Possible values are an AWS account ID, an AWS Organizations Organization ARN, or an AWS Organizations Organization Unit ARN."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.principal)) || can(regex("^arn:aws:organizations::[0-9]{12}:(organization|ou)/[a-z0-9-]+/[a-z0-9-]+$", var.principal))
    error_message = "resource_aws_ram_principal_association, principal must be either a 12-digit AWS account ID or a valid AWS Organizations ARN."
  }
}

variable "resource_share_arn" {
  description = "The Amazon Resource Name (ARN) of the resource share."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:ram:[a-z0-9-]+:[0-9]{12}:resource-share/[a-f0-9-]+$", var.resource_share_arn))
    error_message = "resource_aws_ram_principal_association, resource_share_arn must be a valid RAM resource share ARN."
  }
}