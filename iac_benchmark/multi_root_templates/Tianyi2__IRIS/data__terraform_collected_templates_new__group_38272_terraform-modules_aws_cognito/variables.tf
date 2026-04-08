########################
#    Resource Naming   #
########################
variable "name" {
  description = "The base name of the resources"
  type        = string
}

variable "lambda_auth_challenge_arn" {
  description = "ARN for the Lambda function used for auth challenge"
  type        = string
}

variable "lambda_function_name" {
  description = "The name of the Lambda function."
  type        = string
}

variable "password_min_length" {
  description = "Minimum password length for Cognito User Pool"
  type        = number
  default     = 12
}

variable "temp_password_validity_days" {
  description = "Validity of temporary passwords in days"
  type        = number
  default     = 7
}

variable "token_validity" {
  description = "Validity duration for tokens in hours"
  type        = number
  default     = 1
}

variable "callback_url" {
  description = "Callback URL for the Cognito User Pool Client"
  type        = string
}

variable "schema" {
  description = "Schema definition for the Cognito User Pool"
  type = list(object({
    attribute_data_type      = string
    developer_only_attribute = bool
    mutable                  = bool
    name                     = string
    required                 = bool
  }))
}

variable "recovery_mechanism" {
  description = "Account recovery settings for the Cognito User Pool"
  type = list(object({
    name     = string
    priority = number
  }))
}

variable "explicit_auth_flows" {
  description = "Explicit authentication flows for the Cognito User Pool Client"
  type        = list(string)
  default     = ["ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH"]
}

variable "allowed_oauth_scopes" {
  description = "Allowed OAuth scopes for the Cognito User Pool Client"
  type        = list(string)
  default     = ["email", "openid"]
}

variable "supported_identity_providers" {
  description = "Supported identity providers for the Cognito User Pool Client"
  type        = list(string)
  default     = ["COGNITO"]
}

variable "allowed_oauth_flows" {
  description = "Allowed OAuth flows for the Cognito User Pool Client"
  type        = list(string)
  default     = ["code"]
}

variable "domain" {
  description = "The omain name."
  type        = string
}

########################
#      Tags Config     #
########################
variable "tags" {
  description = "Tags to assign"
  type        = map(string)
}
