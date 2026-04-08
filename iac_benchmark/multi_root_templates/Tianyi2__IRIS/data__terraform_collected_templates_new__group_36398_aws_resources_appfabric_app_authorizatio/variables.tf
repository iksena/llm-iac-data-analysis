variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "app" {
  description = "The name of the application for valid values see https://docs.aws.amazon.com/appfabric/latest/api/API_CreateAppAuthorization.html."
  type        = string

  validation {
    condition     = var.app != null && var.app != ""
    error_message = "resource_aws_appfabric_app_authorization, app must be a non-empty string."
  }
}

variable "app_bundle_arn" {
  description = "The Amazon Resource Name (ARN) of the app bundle to use for the request."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:appfabric:[a-z0-9-]+:[0-9]{12}:appbundle/[a-zA-Z0-9-]+$", var.app_bundle_arn))
    error_message = "resource_aws_appfabric_app_authorization, app_bundle_arn must be a valid AppFabric app bundle ARN."
  }
}

variable "auth_type" {
  description = "The authorization type for the app authorization valid values are oauth2 and apiKey."
  type        = string

  validation {
    condition     = contains(["oauth2", "apiKey"], var.auth_type)
    error_message = "resource_aws_appfabric_app_authorization, auth_type must be either 'oauth2' or 'apiKey'."
  }
}

variable "api_key_credential" {
  description = "Contains API key credential information."
  type = object({
    api_key = string
  })
  default = null

  validation {
    condition = var.api_key_credential == null || (
      var.api_key_credential != null &&
      var.api_key_credential.api_key != null &&
      var.api_key_credential.api_key != ""
    )
    error_message = "resource_aws_appfabric_app_authorization, api_key_credential.api_key must be a non-empty string when api_key_credential is provided."
  }
}

variable "oauth2_credential" {
  description = "Contains OAuth2 client credential information."
  type = object({
    client_id     = string
    client_secret = string
  })
  default = null

  validation {
    condition = var.oauth2_credential == null || (
      var.oauth2_credential != null &&
      var.oauth2_credential.client_id != null &&
      var.oauth2_credential.client_id != "" &&
      var.oauth2_credential.client_secret != null &&
      var.oauth2_credential.client_secret != ""
    )
    error_message = "resource_aws_appfabric_app_authorization, oauth2_credential.client_id and oauth2_credential.client_secret must be non-empty strings when oauth2_credential is provided."
  }
}

variable "tenant" {
  description = "Contains information about an application tenant, such as the application display name and identifier."
  type = object({
    tenant_display_name = string
    tenant_identifier   = string
  })

  validation {
    condition = (
      var.tenant.tenant_display_name != null &&
      var.tenant.tenant_display_name != "" &&
      var.tenant.tenant_identifier != null &&
      var.tenant.tenant_identifier != ""
    )
    error_message = "resource_aws_appfabric_app_authorization, tenant.tenant_display_name and tenant.tenant_identifier must be non-empty strings."
  }
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.create)) && can(regex("^[0-9]+[smh]$", var.timeouts.update)) && can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    error_message = "resource_aws_appfabric_app_authorization, timeouts values must be valid duration strings (e.g., '30m', '1h', '300s')."
  }
}