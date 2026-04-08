# Required Upwind configuration
variable "upwind_organization_id" {
  description = "The Upwind organization ID."
  type        = string
}

variable "upwind_client_id" {
  description = "The client ID used for authentication with the Upwind Authorization Service."
  type        = string
}

variable "upwind_client_secret" {
  description = "The client secret for authentication with the Upwind Authorization Service."
  type        = string
  sensitive   = true
}

# Required OCI configuration
variable "oci_tenancy_id" {
  description = "The OCI tenancy ID."
  type        = string
}

variable "upwind_orchestrator_compartment" {
  description = "The orchestrator compartment where Upwind resources are created. Can be either a compartment OCID or compartment name."
  type        = string
}

# Optional configuration
variable "enable_cloudscanners" {
  description = "Enable the creation of cloud scanners."
  type        = bool
  default     = false
}

variable "scanner_client_id" {
  description = "The client ID used for authentication with the Upwind Cloudscanner Service."
  type        = string
  default     = ""
}

variable "scanner_client_secret" {
  description = "The client secret for authentication with the Upwind Cloudscanner Service."
  type        = string
  sensitive   = true
  default     = ""
}

variable "enable_dspm_scanning" {
  description = "Enable DSPM scanning by cloud scanners"
  type        = bool
  default     = false
}

variable "resource_suffix" {
  description = "A suffix to append to resource names to ensure uniqueness."
  type        = string
  default     = ""
}

variable "is_dev" {
  description = "Flag to indicate if the environment is a development environment."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default     = {}
}
