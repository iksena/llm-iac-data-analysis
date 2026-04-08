variable "directory_id" {
  description = "Directory identifier for registration in WorkSpaces service"
  type        = string

  validation {
    condition     = length(var.directory_id) > 0
    error_message = "data_aws_workspaces_directory, directory_id must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "data_aws_workspaces_directory, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}