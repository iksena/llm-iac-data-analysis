variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "client_id" {
  description = "The client ID for the client app. Defaults to ALL. If ALL is specified, the css and/or image_file settings will be used for every client that has no UI customization set previously."
  type        = string
  default     = "ALL"
}

variable "css" {
  description = "The CSS values in the UI customization, provided as a String. At least one of css or image_file is required."
  type        = string
  default     = null
}

variable "image_file" {
  description = "The uploaded logo image for the UI customization, provided as a base64-encoded String. Drift detection is not possible for this argument. At least one of css or image_file is required."
  type        = string
  default     = null
}

variable "user_pool_id" {
  description = "The user pool ID for the user pool."
  type        = string

  validation {
    condition     = var.user_pool_id != null && var.user_pool_id != ""
    error_message = "resource_aws_cognito_user_pool_ui_customization, user_pool_id - User pool ID is required and cannot be empty."
  }
}