variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "api_id" {
  description = "API identifier."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.api_id))
    error_message = "data_apigatewayv2_export, api_id must be a valid API identifier containing only lowercase letters and numbers."
  }
}

variable "specification" {
  description = "Version of the API specification to use. OAS30, for OpenAPI 3.0, is the only supported value."
  type        = string

  validation {
    condition     = var.specification == "OAS30"
    error_message = "data_apigatewayv2_export, specification must be 'OAS30' - this is the only supported value."
  }
}

variable "output_type" {
  description = "Output type of the exported definition file. Valid values are JSON and YAML."
  type        = string

  validation {
    condition     = contains(["JSON", "YAML"], var.output_type)
    error_message = "data_apigatewayv2_export, output_type must be either 'JSON' or 'YAML'."
  }
}

variable "export_version" {
  description = "Version of the API Gateway export algorithm. API Gateway uses the latest version by default. Currently, the only supported version is 1.0."
  type        = string
  default     = null

  validation {
    condition     = var.export_version == null || var.export_version == "1.0"
    error_message = "data_apigatewayv2_export, export_version must be '1.0' or null - this is the only supported version."
  }
}

variable "include_extensions" {
  description = "Whether to include API Gateway extensions in the exported API definition. API Gateway extensions are included by default."
  type        = bool
  default     = null
}

variable "stage_name" {
  description = "Name of the API stage to export. If you don't specify this property, a representation of the latest API configuration is exported."
  type        = string
  default     = null

  validation {
    condition     = var.stage_name == null || can(regex("^[a-zA-Z0-9_-]+$", var.stage_name))
    error_message = "data_apigatewayv2_export, stage_name must be a valid stage name containing only letters, numbers, underscores, and hyphens."
  }
}