variable "function_arn" {
  description = "ARN of the Lambda Function, omitting any version or alias qualifier."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:lambda:", var.function_arn))
    error_message = "data_aws_connect_lambda_function_association, function_arn must be a valid Lambda function ARN starting with 'arn:aws:lambda:'."
  }
}

variable "instance_id" {
  description = "Identifier of the Amazon Connect instance. You can find the instanceId in the ARN of the instance."
  type        = string

  validation {
    condition     = can(regex("^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$", var.instance_id))
    error_message = "data_aws_connect_lambda_function_association, instance_id must be a valid UUID format (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_connect_lambda_function_association, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}