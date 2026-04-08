### region oci

variable "oci_region" {
  description = "The OCI region where resources will be created"
  type        = string
  default     = "us-ashburn-1"
}

### endregion oci

### region secrets

variable "upwind_client_id" {
  description = "The client ID used for authentication with the Upwind Authorization Service."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9]{1,}", var.upwind_client_id))
    error_message = "The Upwind client ID must be alphanumeric."
  }
}

variable "upwind_client_secret" {
  description = "The client secret for authentication with the Upwind Authorization Service."
  type        = string
  sensitive   = true
}

variable "scanner_client_id" {
  description = "The client ID used for authentication with the Upwind Cloudscanner Service."
  type        = string
  default     = ""

  validation {
    condition     = var.scanner_client_id == "" || (can(regex("^[a-zA-Z0-9]{1,}", var.scanner_client_id)))
    error_message = "The Upwind scanner client ID must be empty or alphanumeric."
  }
}

variable "scanner_client_secret" {
  description = "The client secret for authentication with the Upwind Cloudscanner Service."
  type        = string
  sensitive   = true
  default     = ""
}

variable "oci_vault_id" {
  description = "Optional OCID of an existing OCI Vault to use for storing secrets. If not provided, a new vault will be created."
  type        = string
  default     = ""

  validation {
    condition     = var.oci_vault_id == "" || can(regex("^ocid1\\.vault\\..*", var.oci_vault_id))
    error_message = "The OCI vault ID must be a valid OCI vault OCID (starts with ocid1.vault)."
  }
}

variable "oci_vault_key_id" {
  description = "Optional OCID of an existing OCI Vault Key to use for encrypting secrets. If not provided and oci_vault_id is provided, a new key will be created in the existing vault."
  type        = string
  default     = ""

  validation {
    condition     = var.oci_vault_key_id == "" || can(regex("^ocid1\\.key\\..*", var.oci_vault_key_id))
    error_message = "The OCI vault key ID must be a valid OCI key OCID (starts with ocid1.key)."
  }
}

# endregion secrets

# region workload identity federation
variable "root_level_compartment_id" {
  description = "The root-level compartment ID for workload identity federation resources. For tenant module: tenancy_id. For compartment module: orchestrator compartment_id. Used for both identity domain and WIF policy creation."
  type        = string

  validation {
    condition     = can(regex("^ocid1\\.(tenancy|compartment)\\..*", var.root_level_compartment_id))
    error_message = "The root_level_compartment_id must be a valid OCI tenancy or compartment OCID."
  }
}

variable "oci_domain_id" {
  description = "The OCID of an existing OCI Identity Domain to use for federation. If provided, domain creation is skipped and this domain is used. If not provided, a new domain will be created."
  type        = string
  default     = ""

  validation {
    condition     = var.oci_domain_id == "" || can(regex("^ocid1\\.domain\\..*", var.oci_domain_id))
    error_message = "The OCI Domain ID must be valid (starts with ocid1.domain)."
  }
}

variable "identity_domain_display_name" {
  description = "Display name for the identity domain when creating a new one."
  type        = string
  default     = ""
}

variable "identity_domain_description" {
  description = "Description for the identity domain when creating a new one."
  type        = string
  default     = "Identity domain for Upwind workload identity federation"
}

variable "identity_domain_license_type" {
  description = "License type for the identity domain. Valid values: 'FREE', 'PREMIUM'"
  type        = string
  default     = "free"

  validation {
    condition     = contains(["free", "premium"], var.identity_domain_license_type)
    error_message = "The identity_domain_license_type must be one of: free, premium."
  }
}

variable "identity_domain_name" {
  description = "The name of the OCI Identity Domain (e.g., 'Default'). Used in policy statements for domain-scoped groups."
  type        = string
  default     = ""
}

variable "identity_domain_oidc_issuer_url" {
  description = "The OIDC issuer URL for the Identity Domain. If not provided, will be constructed from domain ID."
  type        = string
  default     = ""
}

variable "aws_federated_group_name" {
  description = "The name of the group in the Identity Domain that AWS federated users belong to"
  type        = string
  default     = "aws-federated-workloads"
}

# endregion workload identity federation

# region upwind

variable "upwind_organization_id" {
  description = "The identifier of the Upwind organization to integrate with."
  type        = string

  validation {
    condition     = can(regex("org_[a-zA-Z0-9]{1,}", var.upwind_organization_id))
    error_message = "The Upwind organization ID must start with 'org_' followed by alphanumeric characters."
  }
}

variable "upwind_orchestrator_compartment_id" {
  description = "The orchestrator compartment where Upwind resources are created."
  type        = string

  validation {
    condition     = can(regex("^ocid1\\.(compartment|tenancy)\\..*", var.upwind_orchestrator_compartment_id))
    error_message = "The Upwind orchestrator compartment ID must be a valid OCI compartment or tenancy OCID."
  }
}

variable "orchestrator_compartment_id" {
  description = "The specific orchestrator compartment ID for targeted operations (separate from IAM deployment location)."
  type        = string
  default     = null

  validation {
    condition     = var.orchestrator_compartment_id == null || can(regex("^ocid1\\.(compartment|tenancy)\\..*", var.orchestrator_compartment_id))
    error_message = "The orchestrator compartment ID must be a valid OCI compartment or tenancy OCID."
  }
}

variable "oci_tenancy_id" {
  description = "The OCI tenancy ID or compartment ID."
  type        = string

  validation {
    condition     = can(regex("^ocid1\\.(tenancy|compartment)\\..*", var.oci_tenancy_id))
    error_message = "The OCI tenancy ID must be a valid OCI tenancy or compartment OCID."
  }
}

variable "resource_suffix" {
  description = "The suffix to append to all resources created by this module."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9]{0,10}$", var.resource_suffix))
    error_message = "The resource suffix must be alphanumeric and cannot exceed 10 characters."
  }
}

variable "enable_cloudscanners" {
  description = "Enable CloudScanner resources"
  type        = bool
  default     = true
}

variable "upwind_region" {
  description = "The region of the Upwind organization."
  type        = string
  default     = "us"

  validation {
    condition     = var.upwind_region == "us" || var.upwind_region == "eu" || var.upwind_region == "me" || var.upwind_region == "pdc01"
    error_message = "The Upwind region must be one of: us, eu, me, pdc01."
  }
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

  validation {
    condition = alltrue([
      for k, v in var.tags :
      can(regex("^[a-zA-Z0-9_.-]{1,100}$", k)) && can(regex("^[a-zA-Z0-9_.-]{0,100}$", v))
    ])
    error_message = "Invalid tags found: ${join(", ", [for k, v in var.tags : !can(regex("^[a-zA-Z0-9_.-]{1,100}$", k)) || !can(regex("^[a-zA-Z0-9_.-]{0,100}$", v)) ? "'${k}=${v}'" : ""])}. Tag keys must be 1-100 characters and tag values must be 0-100 characters of letters, numbers, underscores, dots, or hyphens."
  }
}

variable "default_tags" {
  description = "Default tags applied to all resources (can be overridden)"
  type        = map(string)
  default = {
    managed_by = "terraform"
    component  = "upwind"
  }
  validation {
    condition = alltrue([
      for k, v in var.default_tags :
      can(regex("^[a-zA-Z0-9_.-]{1,100}$", k)) && can(regex("^[a-zA-Z0-9_.-]{0,100}$", v))
    ])
    error_message = "Invalid default tags found: ${join(", ", [for k, v in var.default_tags : !can(regex("^[a-zA-Z0-9_.-]{1,100}$", k)) || !can(regex("^[a-zA-Z0-9_.-]{0,100}$", v)) ? "'${k}=${v}'" : ""])}. Tag keys must be 1-100 characters and tag values must be 0-100 characters of letters, numbers, underscores, dots, or hyphens."
  }
}

# endregion upwind
