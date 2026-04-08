variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_servicequotas_template_association, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "skip_destroy" {
  description = "Skip disassociating the quota increase template upon destruction. This will remove the resource from Terraform state, but leave the remote association in place."
  type        = bool
  default     = false

  validation {
    condition     = can(tobool(var.skip_destroy))
    error_message = "resource_aws_servicequotas_template_association, skip_destroy must be a boolean value (true or false)."
  }
}