variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "task_definition" {
  description = "ARN of the task definition which contains the container"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:ecs:.+:.+:task-definition/.+", var.task_definition))
    error_message = "data_aws_ecs_container_definition, task_definition must be a valid ECS task definition ARN."
  }
}

variable "container_name" {
  description = "Name of the container definition"
  type        = string

  validation {
    condition     = length(var.container_name) > 0
    error_message = "data_aws_ecs_container_definition, container_name cannot be empty."
  }
}