variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "rest_api_id" {
  description = "Identifier of the associated REST API."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.rest_api_id))
    error_message = "data_aws_api_gateway_sdk, rest_api_id must contain only lowercase letters and numbers."
  }
}

variable "stage_name" {
  description = "Name of the Stage that will be exported."
  type        = string

  validation {
    condition     = length(var.stage_name) > 0 && length(var.stage_name) <= 128
    error_message = "data_aws_api_gateway_sdk, stage_name must be between 1 and 128 characters."
  }
}

variable "sdk_type" {
  description = "Language for the generated SDK. Currently java, javascript, android, objectivec (for iOS), swift (for iOS), and ruby are supported."
  type        = string

  validation {
    condition     = contains(["java", "javascript", "android", "objectivec", "swift", "ruby"], var.sdk_type)
    error_message = "data_aws_api_gateway_sdk, sdk_type must be one of: java, javascript, android, objectivec, swift, ruby."
  }
}

variable "parameters" {
  description = "Key-value map of query string parameters sdk_type properties of the SDK. For SDK Type of objectivec or swift, a parameter named classPrefix is required. For SDK Type of android, parameters named groupId, artifactId, artifactVersion, and invokerPackage are required. For SDK Type of java, parameters named serviceName and javaPackageName are required."
  type        = map(string)
  default     = {}

  validation {
    condition     = var.sdk_type != "objectivec" || can(var.parameters["classPrefix"])
    error_message = "data_aws_api_gateway_sdk, parameters must include 'classPrefix' when sdk_type is 'objectivec'."
  }

  validation {
    condition     = var.sdk_type != "swift" || can(var.parameters["classPrefix"])
    error_message = "data_aws_api_gateway_sdk, parameters must include 'classPrefix' when sdk_type is 'swift'."
  }

  validation {
    condition     = var.sdk_type != "android" || (can(var.parameters["groupId"]) && can(var.parameters["artifactId"]) && can(var.parameters["artifactVersion"]) && can(var.parameters["invokerPackage"]))
    error_message = "data_aws_api_gateway_sdk, parameters must include 'groupId', 'artifactId', 'artifactVersion', and 'invokerPackage' when sdk_type is 'android'."
  }

  validation {
    condition     = var.sdk_type != "java" || (can(var.parameters["serviceName"]) && can(var.parameters["javaPackageName"]))
    error_message = "data_aws_api_gateway_sdk, parameters must include 'serviceName' and 'javaPackageName' when sdk_type is 'java'."
  }
}