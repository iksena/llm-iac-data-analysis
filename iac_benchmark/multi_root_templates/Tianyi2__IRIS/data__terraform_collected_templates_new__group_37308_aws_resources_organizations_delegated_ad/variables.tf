variable "account_id" {
  description = "The account ID number of the member account in the organization to register as a delegated administrator"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "resource_aws_organizations_delegated_administrator, account_id must be a 12-digit AWS account ID."
  }
}

variable "service_principal" {
  description = "The service principal of the AWS service for which you want to make the member account a delegated administrator"
  type        = string

  validation {
    condition     = length(var.service_principal) > 0
    error_message = "resource_aws_organizations_delegated_administrator, service_principal cannot be empty."
  }
}