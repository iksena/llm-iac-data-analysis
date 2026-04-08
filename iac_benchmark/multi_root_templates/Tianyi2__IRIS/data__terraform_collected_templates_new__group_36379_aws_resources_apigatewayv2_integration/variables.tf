variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "api_id" {
  type        = string
  description = "API identifier."

  validation {
    condition     = length(var.api_id) > 0
    error_message = "resource_aws_apigatewayv2_integration, api_id must not be empty."
  }
}

variable "integration_type" {
  type        = string
  description = "Integration type of an integration. Valid values: AWS (supported only for WebSocket APIs), AWS_PROXY, HTTP (supported only for WebSocket APIs), HTTP_PROXY, MOCK (supported only for WebSocket APIs)."

  validation {
    condition     = contains(["AWS", "AWS_PROXY", "HTTP", "HTTP_PROXY", "MOCK"], var.integration_type)
    error_message = "resource_aws_apigatewayv2_integration, integration_type must be one of: AWS, AWS_PROXY, HTTP, HTTP_PROXY, MOCK."
  }
}

variable "connection_id" {
  type        = string
  description = "ID of the VPC link for a private integration. Supported only for HTTP APIs. Must be between 1 and 1024 characters in length."
  default     = null

  validation {
    condition     = var.connection_id == null || (length(var.connection_id) >= 1 && length(var.connection_id) <= 1024)
    error_message = "resource_aws_apigatewayv2_integration, connection_id must be between 1 and 1024 characters in length."
  }
}

variable "connection_type" {
  type        = string
  description = "Type of the network connection to the integration endpoint. Valid values: INTERNET, VPC_LINK. Default is INTERNET."
  default     = "INTERNET"

  validation {
    condition     = contains(["INTERNET", "VPC_LINK"], var.connection_type)
    error_message = "resource_aws_apigatewayv2_integration, connection_type must be one of: INTERNET, VPC_LINK."
  }
}

variable "content_handling_strategy" {
  type        = string
  description = "How to handle response payload content type conversions. Valid values: CONVERT_TO_BINARY, CONVERT_TO_TEXT. Supported only for WebSocket APIs."
  default     = null

  validation {
    condition     = var.content_handling_strategy == null || contains(["CONVERT_TO_BINARY", "CONVERT_TO_TEXT"], var.content_handling_strategy)
    error_message = "resource_aws_apigatewayv2_integration, content_handling_strategy must be one of: CONVERT_TO_BINARY, CONVERT_TO_TEXT."
  }
}

variable "credentials_arn" {
  type        = string
  description = "Credentials required for the integration, if any."
  default     = null
}

variable "description" {
  type        = string
  description = "Description of the integration."
  default     = null
}

variable "integration_method" {
  type        = string
  description = "Integration's HTTP method. Must be specified if integration_type is not MOCK."
  default     = null
}

variable "integration_subtype" {
  type        = string
  description = "AWS service action to invoke. Supported only for HTTP APIs when integration_type is AWS_PROXY. Must be between 1 and 128 characters in length."
  default     = null

  validation {
    condition     = var.integration_subtype == null || (length(var.integration_subtype) >= 1 && length(var.integration_subtype) <= 128)
    error_message = "resource_aws_apigatewayv2_integration, integration_subtype must be between 1 and 128 characters in length."
  }
}

variable "integration_uri" {
  type        = string
  description = "URI of the Lambda function for a Lambda proxy integration, when integration_type is AWS_PROXY. For an HTTP integration, specify a fully-qualified URL. For an HTTP API private integration, specify the ARN of an Application Load Balancer listener, Network Load Balancer listener, or AWS Cloud Map service."
  default     = null
}

variable "passthrough_behavior" {
  type        = string
  description = "Pass-through behavior for incoming requests based on the Content-Type header in the request, and the available mapping templates specified as the request_templates attribute. Valid values: WHEN_NO_MATCH, WHEN_NO_TEMPLATES, NEVER. Default is WHEN_NO_MATCH. Supported only for WebSocket APIs."
  default     = "WHEN_NO_MATCH"

  validation {
    condition     = contains(["WHEN_NO_MATCH", "WHEN_NO_TEMPLATES", "NEVER"], var.passthrough_behavior)
    error_message = "resource_aws_apigatewayv2_integration, passthrough_behavior must be one of: WHEN_NO_MATCH, WHEN_NO_TEMPLATES, NEVER."
  }
}

variable "payload_format_version" {
  type        = string
  description = "The format of the payload sent to an integration. Valid values: 1.0, 2.0. Default is 1.0."
  default     = "1.0"

  validation {
    condition     = contains(["1.0", "2.0"], var.payload_format_version)
    error_message = "resource_aws_apigatewayv2_integration, payload_format_version must be one of: 1.0, 2.0."
  }
}

variable "request_parameters" {
  type        = map(string)
  description = "For WebSocket APIs, a key-value map specifying request parameters that are passed from the method request to the backend. For HTTP APIs with a specified integration_subtype, a key-value map specifying parameters that are passed to AWS_PROXY integrations. For HTTP APIs without a specified integration_subtype, a key-value map specifying how to transform HTTP requests before sending them to the backend."
  default     = {}
}

variable "request_templates" {
  type        = map(string)
  description = "Map of Velocity templates that are applied on the request payload based on the value of the Content-Type header sent by the client. Supported only for WebSocket APIs."
  default     = {}
}

variable "response_parameters" {
  type = list(object({
    status_code = number
    mappings    = map(string)
  }))
  description = "Mappings to transform the HTTP response from a backend integration before returning the response to clients. Supported only for HTTP APIs."
  default     = []

  validation {
    condition = alltrue([
      for rp in var.response_parameters : rp.status_code >= 200 && rp.status_code <= 599
    ])
    error_message = "resource_aws_apigatewayv2_integration, response_parameters status_code must be in the range 200-599."
  }
}

variable "template_selection_expression" {
  type        = string
  description = "The template selection expression for the integration."
  default     = null
}

variable "timeout_milliseconds" {
  type        = number
  description = "Custom timeout between 50 and 29,000 milliseconds for WebSocket APIs and between 50 and 30,000 milliseconds for HTTP APIs. The default timeout is 29 seconds for WebSocket APIs and 30 seconds for HTTP APIs."
  default     = null

  validation {
    condition     = var.timeout_milliseconds == null || (var.timeout_milliseconds >= 50 && var.timeout_milliseconds <= 30000)
    error_message = "resource_aws_apigatewayv2_integration, timeout_milliseconds must be between 50 and 30,000 milliseconds."
  }
}

variable "tls_config" {
  type = object({
    server_name_to_verify = optional(string)
  })
  description = "TLS configuration for a private integration. Supported only for HTTP APIs."
  default     = null
}