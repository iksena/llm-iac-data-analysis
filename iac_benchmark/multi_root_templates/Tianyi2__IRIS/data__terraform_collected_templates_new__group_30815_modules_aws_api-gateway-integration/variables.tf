variable "lambda_name" {
  type = string
}

variable "lambda_arn" {
  type = string
}

variable "integration_type" {
  type = string
}

variable "apigw_id" {
  type = string
}

variable "method" {
  type = string
}

variable "path" {
  type = string
}

variable "apigw_execution_arn" {
  type = string
}

variable "enable_cognito_authorizer" {
  type = bool
  default = false
}

variable "authorizer_id" {
  type = string
  default = ""
}