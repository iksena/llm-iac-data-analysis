variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name for your compute environment. Up to 128 letters (uppercase and lowercase), numbers, and underscores are allowed. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || can(regex("^[a-zA-Z0-9_]{1,128}$", var.name))
    error_message = "resource_aws_batch_compute_environment, name must be up to 128 letters (uppercase and lowercase), numbers, and underscores."
  }
}

variable "name_prefix" {
  description = "Creates a unique compute environment name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null

  validation {
    condition     = var.name_prefix == null || can(regex("^[a-zA-Z0-9_]+$", var.name_prefix))
    error_message = "resource_aws_batch_compute_environment, name_prefix must contain only letters, numbers, and underscores."
  }
}

variable "compute_resources" {
  description = "Details of the compute resources managed by the compute environment. This parameter is required for managed compute environments."
  type = object({
    allocation_strategy = optional(string)
    bid_percentage      = optional(number)
    desired_vcpus       = optional(number)
    ec2_configuration = optional(list(object({
      image_id_override        = optional(string)
      image_kubernetes_version = optional(string)
      image_type               = optional(string)
    })))
    ec2_key_pair  = optional(string)
    image_id      = optional(string)
    instance_role = optional(string)
    instance_type = optional(list(string))
    launch_template = optional(object({
      launch_template_id   = optional(string)
      launch_template_name = optional(string)
      version              = optional(string)
    }))
    max_vcpus           = number
    min_vcpus           = optional(number)
    placement_group     = optional(string)
    security_group_ids  = optional(list(string))
    spot_iam_fleet_role = optional(string)
    subnets             = list(string)
    tags                = optional(map(string))
    type                = string
  })
  default = null

  validation {
    condition = var.compute_resources == null || (
      var.compute_resources.type != null &&
      contains(["EC2", "SPOT", "FARGATE", "FARGATE_SPOT"], var.compute_resources.type)
    )
    error_message = "resource_aws_batch_compute_environment, compute_resources type must be one of: EC2, SPOT, FARGATE, FARGATE_SPOT."
  }

  validation {
    condition = var.compute_resources == null || (
      var.compute_resources.allocation_strategy == null ||
      contains([
        "BEST_FIT", "BEST_FIT_PROGRESSIVE", "SPOT_CAPACITY_OPTIMIZED"
      ], var.compute_resources.allocation_strategy)
    )
    error_message = "resource_aws_batch_compute_environment, compute_resources allocation_strategy must be one of: BEST_FIT, BEST_FIT_PROGRESSIVE, SPOT_CAPACITY_OPTIMIZED."
  }

  validation {
    condition = var.compute_resources == null || (
      var.compute_resources.bid_percentage == null ||
      (var.compute_resources.bid_percentage >= 0 && var.compute_resources.bid_percentage <= 100)
    )
    error_message = "resource_aws_batch_compute_environment, compute_resources bid_percentage must be between 0 and 100."
  }

  validation {
    condition = var.compute_resources == null || (
      var.compute_resources.max_vcpus >= 0
    )
    error_message = "resource_aws_batch_compute_environment, compute_resources max_vcpus must be greater than or equal to 0."
  }

  validation {
    condition = var.compute_resources == null || (
      var.compute_resources.min_vcpus == null ||
      var.compute_resources.min_vcpus >= 0
    )
    error_message = "resource_aws_batch_compute_environment, compute_resources min_vcpus must be greater than or equal to 0."
  }

  validation {
    condition = var.compute_resources == null || (
      var.compute_resources.desired_vcpus == null ||
      var.compute_resources.desired_vcpus >= 0
    )
    error_message = "resource_aws_batch_compute_environment, compute_resources desired_vcpus must be greater than or equal to 0."
  }
}

variable "eks_configuration" {
  description = "Details for the Amazon EKS cluster that supports the compute environment."
  type = object({
    eks_cluster_arn      = string
    kubernetes_namespace = string
  })
  default = null

  validation {
    condition = var.eks_configuration == null || (
      var.eks_configuration.eks_cluster_arn != null &&
      can(regex("^arn:aws:eks:", var.eks_configuration.eks_cluster_arn))
    )
    error_message = "resource_aws_batch_compute_environment, eks_configuration eks_cluster_arn must be a valid EKS cluster ARN."
  }

  validation {
    condition = var.eks_configuration == null || (
      var.eks_configuration.kubernetes_namespace != null &&
      length(var.eks_configuration.kubernetes_namespace) > 0
    )
    error_message = "resource_aws_batch_compute_environment, eks_configuration kubernetes_namespace must be a non-empty string."
  }
}

variable "service_role" {
  description = "The full Amazon Resource Name (ARN) of the IAM role that allows AWS Batch to make calls to other AWS services on your behalf."
  type        = string
  default     = null

  validation {
    condition     = var.service_role == null || can(regex("^arn:aws:iam::", var.service_role))
    error_message = "resource_aws_batch_compute_environment, service_role must be a valid IAM role ARN."
  }
}

variable "state" {
  description = "The state of the compute environment. If the state is ENABLED, then the compute environment accepts jobs from a queue and can scale out automatically based on queues. Valid items are ENABLED or DISABLED. Defaults to ENABLED."
  type        = string
  default     = "ENABLED"

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.state)
    error_message = "resource_aws_batch_compute_environment, state must be either ENABLED or DISABLED."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "type" {
  description = "The type of the compute environment. Valid items are MANAGED or UNMANAGED."
  type        = string

  validation {
    condition     = contains(["MANAGED", "UNMANAGED"], var.type)
    error_message = "resource_aws_batch_compute_environment, type must be either MANAGED or UNMANAGED."
  }
}

variable "update_policy" {
  description = "Specifies the infrastructure update policy for the compute environment."
  type = object({
    job_execution_timeout_minutes = number
    terminate_jobs_on_update      = bool
  })
  default = null

  validation {
    condition = var.update_policy == null || (
      var.update_policy.job_execution_timeout_minutes >= 1
    )
    error_message = "resource_aws_batch_compute_environment, update_policy job_execution_timeout_minutes must be greater than or equal to 1."
  }
}