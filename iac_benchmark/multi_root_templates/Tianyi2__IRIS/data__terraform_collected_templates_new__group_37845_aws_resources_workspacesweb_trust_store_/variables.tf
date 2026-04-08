variable "trust_store_arn" {
  description = "ARN of the trust store to associate with the portal. Forces replacement if changed."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:workspaces-web:[a-z0-9-]+:[0-9]{12}:trustStore/[a-zA-Z0-9-]+$", var.trust_store_arn))
    error_message = "resource_aws_workspacesweb_trust_store_association, trust_store_arn must be a valid WorkSpaces Web trust store ARN."
  }
}

variable "portal_arn" {
  description = "ARN of the portal to associate with the trust store. Forces replacement if changed."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:workspaces-web:[a-z0-9-]+:[0-9]{12}:portal/[a-zA-Z0-9-]+$", var.portal_arn))
    error_message = "resource_aws_workspacesweb_trust_store_association, portal_arn must be a valid WorkSpaces Web portal ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_workspacesweb_trust_store_association, region must be a valid AWS region name."
  }
}