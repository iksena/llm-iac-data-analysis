variable "service_name" {
  description = "The name of the AWS service that is to be associated with the credentials. The service you specify here is the only service that can be accessed using these credentials."
  type        = string

  validation {
    condition     = length(var.service_name) > 0
    error_message = "resource_aws_iam_service_specific_credential, service_name must not be empty."
  }
}

variable "user_name" {
  description = "The name of the IAM user that is to be associated with the credentials. The new service-specific credentials have the same permissions as the associated user except that they can be used only to access the specified service."
  type        = string

  validation {
    condition     = length(var.user_name) > 0
    error_message = "resource_aws_iam_service_specific_credential, user_name must not be empty."
  }
}

variable "status" {
  description = "The status to be assigned to the service-specific credential. Valid values are Active and Inactive. Default value is Active."
  type        = string
  default     = "Active"

  validation {
    condition     = contains(["Active", "Inactive"], var.status)
    error_message = "resource_aws_iam_service_specific_credential, status must be either 'Active' or 'Inactive'."
  }
}