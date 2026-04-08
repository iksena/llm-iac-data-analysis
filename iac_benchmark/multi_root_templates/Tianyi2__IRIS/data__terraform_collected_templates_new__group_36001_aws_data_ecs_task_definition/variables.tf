variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_ecs_task_definition, region must be a valid AWS region format (e.g., us-east-1, eu-west-2) or null."
  }
}

variable "task_definition" {
  description = "Family for the latest ACTIVE revision, family and revision (family:revision) for a specific revision in the family, the ARN of the task definition to access to."
  type        = string

  validation {
    condition     = length(var.task_definition) > 0
    error_message = "data_aws_ecs_task_definition, task_definition cannot be empty."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.task_definition)) || can(regex("^[a-zA-Z0-9_-]+:[0-9]+$", var.task_definition)) || can(regex("^arn:aws[a-zA-Z0-9-]*:ecs:[a-z0-9-]+:[0-9]{12}:task-definition/[a-zA-Z0-9_-]+(:[0-9]+)?$", var.task_definition))
    error_message = "data_aws_ecs_task_definition, task_definition must be a valid family name, family:revision, or task definition ARN."
  }
}