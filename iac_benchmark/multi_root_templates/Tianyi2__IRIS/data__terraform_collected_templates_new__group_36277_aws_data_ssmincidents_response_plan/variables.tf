variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "arn" {
  description = "The Amazon Resource Name (ARN) of the response plan."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:ssm-incidents:[a-z0-9-]+:[0-9]{12}:response-plan/.+", var.arn))
    error_message = "data_aws_ssmincidents_response_plan, arn must be a valid AWS Systems Manager Incident Manager response plan ARN."
  }
}