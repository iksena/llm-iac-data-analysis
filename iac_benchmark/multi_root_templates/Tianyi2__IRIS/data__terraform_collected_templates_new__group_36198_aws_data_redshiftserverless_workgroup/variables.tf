variable "workgroup_name" {
  description = "The name of the workgroup associated with the database"
  type        = string

  validation {
    condition     = length(var.workgroup_name) > 0
    error_message = "data_aws_redshiftserverless_workgroup, workgroup_name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || length(var.region) > 0
    error_message = "data_aws_redshiftserverless_workgroup, region must not be empty if specified."
  }
}