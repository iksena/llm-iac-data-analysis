variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "env_id" {
  description = "The system-generated unique ID of the Dev Environment for which you want to view information. To retrieve a list of Dev Environment IDs, use ListDevEnvironments."
  type        = string

  validation {
    condition     = length(var.env_id) > 0
    error_message = "data_codecatalyst_dev_environment, env_id must not be empty."
  }
}

variable "project_name" {
  description = "The name of the project in the space."
  type        = string

  validation {
    condition     = length(var.project_name) > 0
    error_message = "data_codecatalyst_dev_environment, project_name must not be empty."
  }
}

variable "space_name" {
  description = "The name of the space."
  type        = string

  validation {
    condition     = length(var.space_name) > 0
    error_message = "data_codecatalyst_dev_environment, space_name must not be empty."
  }
}