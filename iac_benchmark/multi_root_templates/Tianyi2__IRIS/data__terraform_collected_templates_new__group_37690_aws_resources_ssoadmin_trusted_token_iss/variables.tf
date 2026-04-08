variable "instance_arn" {
  description = "ARN of the instance of IAM Identity Center."
  type        = string
  validation {
    condition     = can(regex("^arn:aws:sso:", var.instance_arn))
    error_message = "resource_aws_ssoadmin_trusted_token_issuer, instance_arn must be a valid ARN starting with 'arn:aws:sso:'."
  }
}

variable "name" {
  description = "Name of the trusted token issuer."
  type        = string
  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_ssoadmin_trusted_token_issuer, name cannot be empty."
  }
}

variable "trusted_token_issuer_configuration" {
  description = "A block that specifies settings that apply to the trusted token issuer."
  type = object({
    oidc_jwt_configuration = optional(object({
      claim_attribute_path          = string
      identity_store_attribute_path = string
      issuer_url                    = string
      jwks_retrieval_option         = string
    }))
  })
  validation {
    condition     = var.trusted_token_issuer_configuration.oidc_jwt_configuration != null ? can(regex("^https://", var.trusted_token_issuer_configuration.oidc_jwt_configuration.issuer_url)) : true
    error_message = "resource_aws_ssoadmin_trusted_token_issuer, trusted_token_issuer_configuration.oidc_jwt_configuration.issuer_url must be a valid HTTPS URL."
  }
  validation {
    condition     = var.trusted_token_issuer_configuration.oidc_jwt_configuration != null ? contains(["OPEN_ID_DISCOVERY"], var.trusted_token_issuer_configuration.oidc_jwt_configuration.jwks_retrieval_option) : true
    error_message = "resource_aws_ssoadmin_trusted_token_issuer, trusted_token_issuer_configuration.oidc_jwt_configuration.jwks_retrieval_option must be 'OPEN_ID_DISCOVERY'."
  }
  validation {
    condition     = var.trusted_token_issuer_configuration.oidc_jwt_configuration != null ? length(var.trusted_token_issuer_configuration.oidc_jwt_configuration.claim_attribute_path) > 0 : true
    error_message = "resource_aws_ssoadmin_trusted_token_issuer, trusted_token_issuer_configuration.oidc_jwt_configuration.claim_attribute_path cannot be empty."
  }
  validation {
    condition     = var.trusted_token_issuer_configuration.oidc_jwt_configuration != null ? length(var.trusted_token_issuer_configuration.oidc_jwt_configuration.identity_store_attribute_path) > 0 : true
    error_message = "resource_aws_ssoadmin_trusted_token_issuer, trusted_token_issuer_configuration.oidc_jwt_configuration.identity_store_attribute_path cannot be empty."
  }
}

variable "trusted_token_issuer_type" {
  description = "Specifies the type of the trusted token issuer."
  type        = string
  validation {
    condition     = contains(["OIDC_JWT"], var.trusted_token_issuer_type)
    error_message = "resource_aws_ssoadmin_trusted_token_issuer, trusted_token_issuer_type must be 'OIDC_JWT'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "client_token" {
  description = "A unique, case-sensitive ID that you provide to ensure the idempotency of the request."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value mapping of resource tags."
  type        = map(string)
  default     = {}
}