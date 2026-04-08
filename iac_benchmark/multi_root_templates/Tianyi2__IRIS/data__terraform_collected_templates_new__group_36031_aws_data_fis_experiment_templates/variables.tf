variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_fis_experiment_templates, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}

variable "tags" {
  description = "Map of tags, each pair of which must exactly match a pair on the desired experiment templates."
  type        = map(string)
  default     = {}

  validation {
    condition     = can(var.tags) && length(var.tags) >= 0
    error_message = "data_aws_fis_experiment_templates, tags must be a valid map of strings."
  }
}