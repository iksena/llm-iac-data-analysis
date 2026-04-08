variable "project" {
  description = "Project name to which the resource is associated"
  type        = string
}

variable "client" {
  description = "Client to which the resource is associated"
  type        = string
}

variable "owner" {
  description = "Owner of the resource"
  type        = string
}

variable "environment" {
  description = "The environment for this deployment (e.g., dev, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "qat", "pre", "prd"], var.environment)
    error_message = "The environment variable can only be set to 'dev', 'qat', 'pre' or 'prd'."
  }
}

variable "additional_tags" {
  description = "Any additional tags you want to add to AWS resources"
  type        = map(string)
  default     = {}
}
