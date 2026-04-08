variable "rest_api_id" {
  description = "Identifier of the associated REST API"
  type        = string
}

variable "stage_name" {
  description = "Name of the Stage that will be exported"
  type        = string
}

variable "export_type" {
  description = "Type of export. Acceptable values are oas30 for OpenAPI 3.0.x and swagger for Swagger/OpenAPI 2.0"
  type        = string

  validation {
    condition     = contains(["oas30", "swagger"], var.export_type)
    error_message = "data_aws_api_gateway_export, export_type must be either 'oas30' or 'swagger'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "accepts" {
  description = "Content-type of the export. Valid values are application/json and application/yaml are supported for export_type of oas30 and swagger"
  type        = string
  default     = null

  validation {
    condition     = var.accepts == null || contains(["application/json", "application/yaml"], var.accepts)
    error_message = "data_aws_api_gateway_export, accepts must be either 'application/json' or 'application/yaml'."
  }
}

variable "parameters" {
  description = "Key-value map of query string parameters that specify properties of the export. Supported parameters: extensions='integrations' or extensions='apigateway' will export the API with x-amazon-apigateway-integration extensions. extensions='authorizers' will export the API with x-amazon-apigateway-authorizer extensions"
  type        = map(string)
  default     = null
}