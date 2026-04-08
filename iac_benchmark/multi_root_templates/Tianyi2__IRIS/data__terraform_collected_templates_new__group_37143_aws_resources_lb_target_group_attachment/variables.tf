variable "target_group_arn" {
  description = "The ARN of the target group with which to register targets"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:elasticloadbalancing:", var.target_group_arn))
    error_message = "resource_aws_lb_target_group_attachment, target_group_arn must be a valid ELB target group ARN starting with 'arn:aws:elasticloadbalancing:'."
  }
}

variable "target_id" {
  description = "The ID of the target. This is the Instance ID for an instance, or the container ID for an ECS container. If the target type is ip, specify an IP address. If the target type is lambda, specify the Lambda function ARN. If the target type is alb, specify the ALB ARN"
  type        = string

  validation {
    condition     = length(var.target_id) > 0
    error_message = "resource_aws_lb_target_group_attachment, target_id cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_lb_target_group_attachment, region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "availability_zone" {
  description = "The Availability Zone where the IP address of the target is to be registered. If the private IP address is outside of the VPC scope, this value must be set to all"
  type        = string
  default     = null

  validation {
    condition     = var.availability_zone == null || var.availability_zone == "all" || can(regex("^[a-z]{2}-[a-z]+-[0-9]+[a-z]$", var.availability_zone))
    error_message = "resource_aws_lb_target_group_attachment, availability_zone must be either 'all' or a valid availability zone format (e.g., us-east-1a)."
  }
}

variable "port" {
  description = "The port on which targets receive traffic"
  type        = number
  default     = null

  validation {
    condition     = var.port == null || (var.port >= 1 && var.port <= 65535)
    error_message = "resource_aws_lb_target_group_attachment, port must be between 1 and 65535."
  }
}