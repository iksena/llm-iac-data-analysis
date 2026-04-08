variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "data_aws_ecs_cluster, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "cluster_name" {
  description = "Name of the ECS Cluster"
  type        = string

  validation {
    condition     = length(var.cluster_name) > 0 && length(var.cluster_name) <= 255
    error_message = "data_aws_ecs_cluster, cluster_name must be between 1 and 255 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9_-]*$", var.cluster_name))
    error_message = "data_aws_ecs_cluster, cluster_name must start with a letter or number and can only contain letters, numbers, hyphens, and underscores."
  }
}