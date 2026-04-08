variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "endpoint_type" {
  description = "Endpoint type. Valid values: iot:CredentialProvider, iot:Data, iot:Data-ATS, iot:Jobs."
  type        = string
  default     = null

  validation {
    condition = var.endpoint_type == null || contains([
      "iot:CredentialProvider",
      "iot:Data",
      "iot:Data-ATS",
      "iot:Jobs"
    ], var.endpoint_type)
    error_message = "data_aws_iot_endpoint, endpoint_type must be one of: iot:CredentialProvider, iot:Data, iot:Data-ATS, iot:Jobs."
  }
}