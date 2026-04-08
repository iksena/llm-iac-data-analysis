variable "name" {
  description = "Name of the Domain."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_datazone_domain, name must not be empty."
  }
}

variable "domain_execution_role" {
  description = "ARN of the role used by DataZone to configure the Domain."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/", var.domain_execution_role))
    error_message = "resource_aws_datazone_domain, domain_execution_role must be a valid IAM role ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the Domain."
  type        = string
  default     = null
}

variable "domain_version" {
  description = "Version of the Domain. Valid values are V1 and V2. Defaults to V1."
  type        = string
  default     = "V1"

  validation {
    condition     = contains(["V1", "V2"], var.domain_version)
    error_message = "resource_aws_datazone_domain, domain_version must be either 'V1' or 'V2'."
  }
}

variable "kms_key_identifier" {
  description = "ARN of the KMS key used to encrypt the Amazon DataZone domain, metadata and reporting data."
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_identifier == null || can(regex("^arn:aws[a-zA-Z-]*:kms:[a-zA-Z0-9-]+:[0-9]{12}:key/[a-zA-Z0-9-]+$", var.kms_key_identifier)) || can(regex("^[a-zA-Z0-9-]+$", var.kms_key_identifier))
    error_message = "resource_aws_datazone_domain, kms_key_identifier must be a valid KMS key ARN or key ID."
  }
}

variable "service_role" {
  description = "ARN of the service role used by DataZone. Required when domain_version is set to V2."
  type        = string
  default     = null

  validation {
    condition     = var.service_role == null || can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/", var.service_role))
    error_message = "resource_aws_datazone_domain, service_role must be a valid IAM role ARN."
  }
}

variable "single_sign_on" {
  description = "Single sign on options, used to enable AWS IAM Identity Center for DataZone."
  type = object({
    type            = string
    user_assignment = string
  })
  default = null

  validation {
    condition = var.single_sign_on == null || (
      var.single_sign_on.type != null &&
      var.single_sign_on.user_assignment != null
    )
    error_message = "resource_aws_datazone_domain, single_sign_on type and user_assignment must be provided when single_sign_on is configured."
  }
}

variable "skip_deletion_check" {
  description = "Whether to skip the deletion check for the Domain."
  type        = bool
  default     = null
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    create = string
    delete = string
  })
  default = {
    create = "10m"
    delete = "10m"
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.create)) && can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    error_message = "resource_aws_datazone_domain, timeouts must be in format like '10m', '1h', or '30s'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}