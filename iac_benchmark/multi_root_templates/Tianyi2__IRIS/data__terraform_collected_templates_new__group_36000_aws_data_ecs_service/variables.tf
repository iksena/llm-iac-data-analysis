variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$|^[a-z]{2}-[a-z]+-[0-9][a-z]$", var.region))
    error_message = "data_aws_ecs_service, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "service_name" {
  description = "Name of the ECS Service"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9_-]*$", var.service_name))
    error_message = "data_aws_ecs_service, service_name must be a valid ECS service name containing only alphanumeric characters, hyphens, and underscores."
  }

  validation {
    condition     = length(var.service_name) >= 1 && length(var.service_name) <= 255
    error_message = "data_aws_ecs_service, service_name must be between 1 and 255 characters."
  }
}

variable "cluster_arn" {
  description = "ARN of the ECS Cluster"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:ecs:[a-z0-9-]+:[0-9]{12}:cluster/[a-zA-Z0-9][a-zA-Z0-9_-]*$", var.cluster_arn))
    error_message = "data_aws_ecs_service, cluster_arn must be a valid ECS cluster ARN format."
  }
}