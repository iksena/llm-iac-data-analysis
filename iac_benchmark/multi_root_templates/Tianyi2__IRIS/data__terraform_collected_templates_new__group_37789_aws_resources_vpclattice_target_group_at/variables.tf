variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "target_group_identifier" {
  description = "The ID or Amazon Resource Name (ARN) of the target group."
  type        = string

  validation {
    condition     = length(var.target_group_identifier) > 0
    error_message = "resource_aws_vpclattice_target_group_attachment, target_group_identifier must not be empty."
  }
}

variable "target_id" {
  description = "The ID of the target. If the target type of the target group is INSTANCE, this is an instance ID. If the target type is IP, this is an IP address. If the target type is LAMBDA, this is the ARN of the Lambda function. If the target type is ALB, this is the ARN of the Application Load Balancer."
  type        = string

  validation {
    condition     = length(var.target_id) > 0
    error_message = "resource_aws_vpclattice_target_group_attachment, target_id must not be empty."
  }
}

variable "target_port" {
  description = "This port is used for routing traffic to the target, and defaults to the target group port. However, you can override the default and specify a custom port."
  type        = number
  default     = null

  validation {
    condition     = var.target_port == null || (var.target_port >= 1 && var.target_port <= 65535)
    error_message = "resource_aws_vpclattice_target_group_attachment, target_port must be between 1 and 65535 if specified."
  }
}