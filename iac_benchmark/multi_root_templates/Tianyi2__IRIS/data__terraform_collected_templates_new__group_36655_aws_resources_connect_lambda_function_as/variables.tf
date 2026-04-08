variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]+-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_connect_lambda_function_association, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "function_arn" {
  description = "Amazon Resource Name (ARN) of the Lambda Function, omitting any version or alias qualifier."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:lambda:[a-z]+-[a-z]+-[0-9]+:[0-9]{12}:function:[a-zA-Z0-9-_]+$", var.function_arn))
    error_message = "resource_aws_connect_lambda_function_association, function_arn must be a valid Lambda function ARN without version or alias qualifier."
  }
}

variable "instance_id" {
  description = "The identifier of the Amazon Connect instance. You can find the instanceId in the ARN of the instance."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.instance_id))
    error_message = "resource_aws_connect_lambda_function_association, instance_id must be a valid UUID format."
  }
}