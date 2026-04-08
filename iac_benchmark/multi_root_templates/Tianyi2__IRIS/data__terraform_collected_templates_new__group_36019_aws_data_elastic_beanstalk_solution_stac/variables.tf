variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "most_recent" {
  type        = bool
  description = "If more than one result is returned, use the most recent solution stack."
  default     = null
}

variable "name_regex" {
  type        = string
  description = "Regex string to apply to the solution stack list returned by AWS."
  default     = null

  validation {
    condition     = var.name_regex != null
    error_message = "data_aws_elastic_beanstalk_solution_stack, name_regex must be provided."
  }
}