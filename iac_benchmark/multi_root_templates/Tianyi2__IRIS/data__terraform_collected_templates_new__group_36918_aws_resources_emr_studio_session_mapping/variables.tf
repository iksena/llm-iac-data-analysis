variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "identity_id" {
  description = "The globally unique identifier (GUID) of the user or group from the Amazon Web Services SSO Identity Store."
  type        = string
  default     = null
}

variable "identity_name" {
  description = "The name of the user or group from the Amazon Web Services SSO Identity Store."
  type        = string
  default     = null
}

variable "identity_type" {
  description = "Specifies whether the identity to map to the Amazon EMR Studio is a USER or a GROUP."
  type        = string

  validation {
    condition     = contains(["USER", "GROUP"], var.identity_type)
    error_message = "resource_aws_emr_studio_session_mapping, identity_type must be either 'USER' or 'GROUP'."
  }
}

variable "session_policy_arn" {
  description = "The Amazon Resource Name (ARN) for the session policy that will be applied to the user or group."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:policy/", var.session_policy_arn))
    error_message = "resource_aws_emr_studio_session_mapping, session_policy_arn must be a valid IAM policy ARN."
  }
}

variable "studio_id" {
  description = "The ID of the Amazon EMR Studio to which the user or group will be mapped."
  type        = string

  validation {
    condition     = can(regex("^es-[a-zA-Z0-9]+$", var.studio_id))
    error_message = "resource_aws_emr_studio_session_mapping, studio_id must be a valid EMR Studio ID starting with 'es-'."
  }
}