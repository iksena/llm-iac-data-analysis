variable "directory_id" {
  type        = string
  description = "Identifier of the Managed Microsoft AD directory that you want to share with other accounts"

  validation {
    condition     = can(regex("^d-[0-9a-f]{10}$", var.directory_id))
    error_message = "resource_aws_directory_service_shared_directory, directory_id must be a valid directory ID format (d- followed by 10 alphanumeric characters)"
  }
}

variable "target" {
  type = object({
    id   = string
    type = optional(string, "ACCOUNT")
  })
  description = "Identifier for the directory consumer account with whom the directory is to be shared"

  validation {
    condition     = can(regex("^[0-9]{12}$", var.target.id))
    error_message = "resource_aws_directory_service_shared_directory, target.id must be a valid 12-digit AWS account ID"
  }

  validation {
    condition     = contains(["ACCOUNT"], var.target.type)
    error_message = "resource_aws_directory_service_shared_directory, target.type must be 'ACCOUNT'"
  }
}

variable "region" {
  type        = string
  description = "Region where this resource will be managed"
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_directory_service_shared_directory, region must be a valid AWS region format (e.g., us-east-1)"
  }
}

variable "method" {
  type        = string
  description = "Method used when sharing a directory"
  default     = "HANDSHAKE"

  validation {
    condition     = contains(["ORGANIZATIONS", "HANDSHAKE"], var.method)
    error_message = "resource_aws_directory_service_shared_directory, method must be either 'ORGANIZATIONS' or 'HANDSHAKE'"
  }
}

variable "notes" {
  type        = string
  description = "Message sent by the directory owner to the directory consumer to help the directory consumer administrator determine whether to approve or reject the share invitation"
  default     = null
  sensitive   = true
}

variable "timeouts" {
  type = object({
    delete = optional(string, "60m")
  })
  description = "Timeouts configuration for the resource"
  default     = {}

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    error_message = "resource_aws_directory_service_shared_directory, timeouts.delete must be a valid timeout format (e.g., 60m, 1h, 30s)"
  }
}