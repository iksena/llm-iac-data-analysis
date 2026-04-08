variable "name" {
  description = "Name of the job definition."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.name))
    error_message = "resource_aws_batch_job_definition, name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "type" {
  description = "Type of job definition. Must be container or multinode."
  type        = string

  validation {
    condition     = contains(["container", "multinode"], var.type)
    error_message = "resource_aws_batch_job_definition, type must be either 'container' or 'multinode'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "container_properties" {
  description = "Valid container properties provided as a single valid JSON document. This parameter is only valid if the type parameter is container."
  type        = string
  default     = null

  validation {
    condition     = var.container_properties == null || (var.type == "container" && can(jsonencode(jsondecode(var.container_properties))))
    error_message = "resource_aws_batch_job_definition, container_properties must be valid JSON and type must be 'container'."
  }
}

variable "deregister_on_new_revision" {
  description = "When updating a job definition a new revision is created. This parameter determines if the previous version is deregistered (INACTIVE) or left ACTIVE. Defaults to true."
  type        = bool
  default     = true
}

variable "ecs_properties" {
  description = "Valid ECS properties provided as a single valid JSON document. This parameter is only valid if the type parameter is container."
  type        = string
  default     = null

  validation {
    condition     = var.ecs_properties == null || (var.type == "container" && can(jsonencode(jsondecode(var.ecs_properties))))
    error_message = "resource_aws_batch_job_definition, ecs_properties must be valid JSON and type must be 'container'."
  }
}

variable "eks_properties" {
  description = "Valid eks properties. This parameter is only valid if the type parameter is container."
  type = object({
    pod_properties = optional(object({
      containers = optional(list(object({
        args    = optional(list(string))
        command = optional(list(string))
        env = optional(list(object({
          name  = string
          value = optional(string)
        })))
        image             = string
        image_pull_policy = optional(string)
        name              = optional(string)
        resources = optional(object({
          limits   = optional(map(string))
          requests = optional(map(string))
        }))
        security_context = optional(object({
          allow_privilege_escalation = optional(bool)
          privileged                 = optional(bool)
          read_only_root_filesystem  = optional(bool)
          run_as_group               = optional(number)
          run_as_non_root            = optional(bool)
          run_as_user                = optional(number)
        }))
        volume_mounts = optional(list(object({
          mount_path = string
          name       = string
          read_only  = optional(bool)
        })))
      })))
      dns_policy   = optional(string)
      host_network = optional(bool)
      init_containers = optional(list(object({
        args    = optional(list(string))
        command = optional(list(string))
        env = optional(list(object({
          name  = string
          value = optional(string)
        })))
        image             = string
        image_pull_policy = optional(string)
        name              = optional(string)
        resources = optional(object({
          limits   = optional(map(string))
          requests = optional(map(string))
        }))
        security_context = optional(object({
          allow_privilege_escalation = optional(bool)
          privileged                 = optional(bool)
          read_only_root_filesystem  = optional(bool)
          run_as_group               = optional(number)
          run_as_non_root            = optional(bool)
          run_as_user                = optional(number)
        }))
        volume_mounts = optional(list(object({
          mount_path = string
          name       = string
          read_only  = optional(bool)
        })))
      })))
      image_pull_secret = optional(list(object({
        name = string
      })))
      metadata = optional(object({
        labels = optional(map(string))
      }))
      service_account_name    = optional(string)
      share_process_namespace = optional(bool)
      volumes = optional(list(object({
        name = string
        empty_dir = optional(object({
          medium     = optional(string)
          size_limit = optional(string)
        }))
        host_path = optional(object({
          path = optional(string)
        }))
        secret = optional(object({
          secret_name = string
          optional    = optional(bool)
        }))
      })))
    }))
  })
  default = null

  validation {
    condition     = var.eks_properties == null || var.type == "container"
    error_message = "resource_aws_batch_job_definition, eks_properties can only be used when type is 'container'."
  }

  validation {
    condition = var.eks_properties == null || (
      var.eks_properties.pod_properties == null ||
      var.eks_properties.pod_properties.dns_policy == null ||
      contains(["ClusterFirst", "ClusterFirstWithHostNet", "Default"], var.eks_properties.pod_properties.dns_policy)
    )
    error_message = "resource_aws_batch_job_definition, dns_policy must be one of: ClusterFirst, ClusterFirstWithHostNet, Default."
  }

  validation {
    condition = var.eks_properties == null || (
      var.eks_properties.pod_properties == null ||
      var.eks_properties.pod_properties.containers == null ||
      alltrue([
        for container in var.eks_properties.pod_properties.containers :
        container.image_pull_policy == null || contains(["Always", "IfNotPresent", "Never"], container.image_pull_policy)
      ])
    )
    error_message = "resource_aws_batch_job_definition, image_pull_policy must be one of: Always, IfNotPresent, Never."
  }

  validation {
    condition = var.eks_properties == null || (
      var.eks_properties.pod_properties == null ||
      var.eks_properties.pod_properties.init_containers == null ||
      alltrue([
        for container in var.eks_properties.pod_properties.init_containers :
        container.image_pull_policy == null || contains(["Always", "IfNotPresent", "Never"], container.image_pull_policy)
      ])
    )
    error_message = "resource_aws_batch_job_definition, init_containers image_pull_policy must be one of: Always, IfNotPresent, Never."
  }
}

variable "node_properties" {
  description = "Valid node properties provided as a single valid JSON document. This parameter is required if the type parameter is multinode."
  type        = string
  default     = null

  validation {
    condition     = var.node_properties == null || (var.type == "multinode" && can(jsonencode(jsondecode(var.node_properties))))
    error_message = "resource_aws_batch_job_definition, node_properties must be valid JSON and type must be 'multinode'."
  }

  validation {
    condition     = var.type != "multinode" || var.node_properties != null
    error_message = "resource_aws_batch_job_definition, node_properties is required when type is 'multinode'."
  }
}

variable "parameters" {
  description = "Parameter substitution placeholders to set in the job definition."
  type        = map(string)
  default     = null
}

variable "platform_capabilities" {
  description = "Platform capabilities required by the job definition. If no value is specified, it defaults to EC2. To run the job on Fargate resources, specify FARGATE."
  type        = list(string)
  default     = null

  validation {
    condition = var.platform_capabilities == null || alltrue([
      for capability in var.platform_capabilities :
      contains(["EC2", "FARGATE"], capability)
    ])
    error_message = "resource_aws_batch_job_definition, platform_capabilities must contain only 'EC2' and/or 'FARGATE'."
  }
}

variable "propagate_tags" {
  description = "Whether to propagate the tags from the job definition to the corresponding Amazon ECS task. Default is false."
  type        = bool
  default     = false
}

variable "retry_strategy" {
  description = "Retry strategy to use for failed jobs that are submitted with this job definition. Maximum number of retry_strategy is 1."
  type = object({
    attempts = optional(number)
    evaluate_on_exit = optional(list(object({
      action           = string
      on_exit_code     = optional(string)
      on_reason        = optional(string)
      on_status_reason = optional(string)
    })))
  })
  default = null

  validation {
    condition = var.retry_strategy == null || (
      var.retry_strategy.attempts == null ||
      (var.retry_strategy.attempts >= 1 && var.retry_strategy.attempts <= 10)
    )
    error_message = "resource_aws_batch_job_definition, retry_strategy attempts must be between 1 and 10."
  }

  validation {
    condition = var.retry_strategy == null || (
      var.retry_strategy.evaluate_on_exit == null ||
      length(var.retry_strategy.evaluate_on_exit) <= 5
    )
    error_message = "resource_aws_batch_job_definition, retry_strategy can have up to 5 evaluate_on_exit configuration blocks."
  }

  validation {
    condition = var.retry_strategy == null || (
      var.retry_strategy.evaluate_on_exit == null ||
      alltrue([
        for exit_condition in var.retry_strategy.evaluate_on_exit :
        contains(["retry", "exit"], lower(exit_condition.action))
      ])
    )
    error_message = "resource_aws_batch_job_definition, evaluate_on_exit action must be either 'retry' or 'exit'."
  }

  validation {
    condition = var.retry_strategy == null || (
      var.retry_strategy.evaluate_on_exit == null ||
      var.retry_strategy.attempts != null
    )
    error_message = "resource_aws_batch_job_definition, attempts parameter must be specified when evaluate_on_exit is used."
  }
}

variable "scheduling_priority" {
  description = "Scheduling priority of the job definition. This only affects jobs in job queues with a fair share policy. Jobs with a higher scheduling priority are scheduled before jobs with a lower scheduling priority. Allowed values 0 through 9999."
  type        = number
  default     = null

  validation {
    condition     = var.scheduling_priority == null || (var.scheduling_priority >= 0 && var.scheduling_priority <= 9999)
    error_message = "resource_aws_batch_job_definition, scheduling_priority must be between 0 and 9999."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "timeout" {
  description = "Timeout for jobs so that if a job runs longer, AWS Batch terminates the job. Maximum number of timeout is 1."
  type = object({
    attempt_duration_seconds = optional(number)
  })
  default = null

  validation {
    condition = var.timeout == null || (
      var.timeout.attempt_duration_seconds == null ||
      var.timeout.attempt_duration_seconds >= 60
    )
    error_message = "resource_aws_batch_job_definition, timeout attempt_duration_seconds minimum value is 60 seconds."
  }
}