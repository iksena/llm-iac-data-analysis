variable "infrastructure_configuration_arn" {
  description = "Amazon Resource Name (ARN) of the Image Builder Infrastructure Configuration"
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:imagebuilder:[a-z0-9-]+:[0-9]{12}:infrastructure-configuration/[a-zA-Z0-9-_]+$", var.infrastructure_configuration_arn))
    error_message = "resource_aws_imagebuilder_image_pipeline, infrastructure_configuration_arn must be a valid ARN for an Image Builder Infrastructure Configuration."
  }
}

variable "name" {
  description = "Name of the image pipeline"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-_]*$", var.name))
    error_message = "resource_aws_imagebuilder_image_pipeline, name must start with alphanumeric character and can only contain alphanumeric characters, hyphens, and underscores."
  }
}

variable "container_recipe_arn" {
  description = "Amazon Resource Name (ARN) of the container recipe"
  type        = string
  default     = null

  validation {
    condition     = var.container_recipe_arn == null || can(regex("^arn:aws[a-zA-Z-]*:imagebuilder:[a-z0-9-]+:[0-9]{12}:container-recipe/[a-zA-Z0-9-_]+/[0-9]+\\.[0-9]+\\.[0-9]+$", var.container_recipe_arn))
    error_message = "resource_aws_imagebuilder_image_pipeline, container_recipe_arn must be a valid ARN for a container recipe."
  }
}

variable "description" {
  description = "Description of the image pipeline"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 1024
    error_message = "resource_aws_imagebuilder_image_pipeline, description must be 1024 characters or less."
  }
}

variable "distribution_configuration_arn" {
  description = "Amazon Resource Name (ARN) of the Image Builder Distribution Configuration"
  type        = string
  default     = null

  validation {
    condition     = var.distribution_configuration_arn == null || can(regex("^arn:aws[a-zA-Z-]*:imagebuilder:[a-z0-9-]+:[0-9]{12}:distribution-configuration/[a-zA-Z0-9-_]+$", var.distribution_configuration_arn))
    error_message = "resource_aws_imagebuilder_image_pipeline, distribution_configuration_arn must be a valid ARN for a distribution configuration."
  }
}

variable "enhanced_image_metadata_enabled" {
  description = "Whether additional information about the image being created is collected"
  type        = bool
  default     = true
}

variable "execution_role" {
  description = "Amazon Resource Name (ARN) of the service-linked role to be used by Image Builder to execute workflows"
  type        = string
  default     = null

  validation {
    condition     = var.execution_role == null || can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/[a-zA-Z0-9+=,.@_/-]+$", var.execution_role))
    error_message = "resource_aws_imagebuilder_image_pipeline, execution_role must be a valid IAM role ARN."
  }
}

variable "image_recipe_arn" {
  description = "Amazon Resource Name (ARN) of the image recipe"
  type        = string
  default     = null

  validation {
    condition     = var.image_recipe_arn == null || can(regex("^arn:aws[a-zA-Z-]*:imagebuilder:[a-z0-9-]+:[0-9]{12}:image-recipe/[a-zA-Z0-9-_]+/[0-9]+\\.[0-9]+\\.[0-9]+$", var.image_recipe_arn))
    error_message = "resource_aws_imagebuilder_image_pipeline, image_recipe_arn must be a valid ARN for an image recipe."
  }
}

variable "image_scanning_configuration" {
  description = "Configuration block with image scanning configuration"
  type = object({
    image_scanning_enabled = optional(bool, false)
    ecr_configuration = optional(object({
      container_tags  = optional(list(string))
      repository_name = optional(string)
    }))
  })
  default = null
}

variable "image_tests_configuration" {
  description = "Configuration block with image tests configuration"
  type = object({
    image_tests_enabled = optional(bool, true)
    timeout_minutes     = optional(number, 720)
  })
  default = null

  validation {
    condition = var.image_tests_configuration == null || (
      var.image_tests_configuration.timeout_minutes == null ||
      (var.image_tests_configuration.timeout_minutes >= 60 && var.image_tests_configuration.timeout_minutes <= 1440)
    )
    error_message = "resource_aws_imagebuilder_image_pipeline, timeout_minutes must be between 60 and 1440 minutes."
  }
}

variable "schedule" {
  description = "Configuration block with schedule settings"
  type = object({
    schedule_expression                = string
    pipeline_execution_start_condition = optional(string, "EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AVAILABLE")
    timezone                           = optional(string)
  })
  default = null

  validation {
    condition = var.schedule == null || contains([
      "EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AVAILABLE",
      "EXPRESSION_MATCH_ONLY"
    ], var.schedule.pipeline_execution_start_condition)
    error_message = "resource_aws_imagebuilder_image_pipeline, pipeline_execution_start_condition must be either 'EXPRESSION_MATCH_AND_DEPENDENCY_UPDATES_AVAILABLE' or 'EXPRESSION_MATCH_ONLY'."
  }

  validation {
    condition     = var.schedule == null || can(regex("^cron\\(.*\\)$", var.schedule.schedule_expression))
    error_message = "resource_aws_imagebuilder_image_pipeline, schedule_expression must be a valid cron expression starting with 'cron('."
  }
}

variable "status" {
  description = "Status of the image pipeline"
  type        = string
  default     = "ENABLED"

  validation {
    condition     = contains(["DISABLED", "ENABLED"], var.status)
    error_message = "resource_aws_imagebuilder_image_pipeline, status must be either 'DISABLED' or 'ENABLED'."
  }
}

variable "workflow" {
  description = "Configuration block with the workflow configuration"
  type = list(object({
    workflow_arn   = string
    on_failure     = optional(string)
    parallel_group = optional(string)
    parameter = optional(list(object({
      name  = string
      value = string
    })))
  }))
  default = null

  validation {
    condition = var.workflow == null || alltrue([
      for w in var.workflow : can(regex("^arn:aws[a-zA-Z-]*:imagebuilder:[a-z0-9-]+:[0-9]{12}:workflow/[a-zA-Z0-9-_]+/[0-9]+\\.[0-9]+\\.[0-9]+$", w.workflow_arn))
    ])
    error_message = "resource_aws_imagebuilder_image_pipeline, workflow_arn must be a valid ARN for an Image Builder Workflow."
  }

  validation {
    condition = var.workflow == null || alltrue([
      for w in var.workflow : w.on_failure == null || contains(["CONTINUE", "ABORT"], w.on_failure)
    ])
    error_message = "resource_aws_imagebuilder_image_pipeline, on_failure must be either 'CONTINUE' or 'ABORT'."
  }
}

variable "tags" {
  description = "Key-value map of resource tags for the image pipeline"
  type        = map(string)
  default     = {}
}