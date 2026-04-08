variable "infrastructure_configuration_arn" {
  description = "Amazon Resource Name (ARN) of the Image Builder Infrastructure Configuration."
  type        = string
  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:imagebuilder:[a-z0-9-]+:[0-9]{12}:infrastructure-configuration/.+", var.infrastructure_configuration_arn))
    error_message = "resource_aws_imagebuilder_image, infrastructure_configuration_arn must be a valid ARN format for Image Builder Infrastructure Configuration."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "container_recipe_arn" {
  description = "Amazon Resource Name (ARN) of the container recipe."
  type        = string
  default     = null
  validation {
    condition     = var.container_recipe_arn == null || can(regex("^arn:aws[a-zA-Z-]*:imagebuilder:[a-z0-9-]+:[0-9]{12}:container-recipe/.+", var.container_recipe_arn))
    error_message = "resource_aws_imagebuilder_image, container_recipe_arn must be a valid ARN format for Image Builder Container Recipe."
  }
}

variable "distribution_configuration_arn" {
  description = "Amazon Resource Name (ARN) of the Image Builder Distribution Configuration."
  type        = string
  default     = null
  validation {
    condition     = var.distribution_configuration_arn == null || can(regex("^arn:aws[a-zA-Z-]*:imagebuilder:[a-z0-9-]+:[0-9]{12}:distribution-configuration/.+", var.distribution_configuration_arn))
    error_message = "resource_aws_imagebuilder_image, distribution_configuration_arn must be a valid ARN format for Image Builder Distribution Configuration."
  }
}

variable "enhanced_image_metadata_enabled" {
  description = "Whether additional information about the image being created is collected. Defaults to true."
  type        = bool
  default     = true
}

variable "execution_role" {
  description = "Amazon Resource Name (ARN) of the service-linked role to be used by Image Builder to execute workflows."
  type        = string
  default     = null
  validation {
    condition     = var.execution_role == null || can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/.+", var.execution_role))
    error_message = "resource_aws_imagebuilder_image, execution_role must be a valid IAM role ARN."
  }
}

variable "image_recipe_arn" {
  description = "Amazon Resource Name (ARN) of the image recipe."
  type        = string
  default     = null
  validation {
    condition     = var.image_recipe_arn == null || can(regex("^arn:aws[a-zA-Z-]*:imagebuilder:[a-z0-9-]+:[0-9]{12}:image-recipe/.+", var.image_recipe_arn))
    error_message = "resource_aws_imagebuilder_image, image_recipe_arn must be a valid ARN format for Image Builder Image Recipe."
  }
}

variable "image_tests_configuration" {
  description = "Configuration block with image tests configuration."
  type = object({
    region              = optional(string)
    image_tests_enabled = optional(bool, true)
    timeout_minutes     = optional(number, 720)
  })
  default = null
  validation {
    condition = var.image_tests_configuration == null || (
      var.image_tests_configuration.timeout_minutes == null ||
      (var.image_tests_configuration.timeout_minutes >= 60 && var.image_tests_configuration.timeout_minutes <= 1440)
    )
    error_message = "resource_aws_imagebuilder_image, timeout_minutes must be between 60 and 1440."
  }
}

variable "image_scanning_configuration" {
  description = "Configuration block with image scanning configuration."
  type = object({
    region                 = optional(string)
    image_scanning_enabled = optional(bool, false)
    ecr_configuration = optional(object({
      region          = optional(string)
      repository_name = optional(string)
      container_tags  = optional(set(string))
    }))
  })
  default = null
}

variable "workflow" {
  description = "Configuration block with the workflow configuration."
  type = list(object({
    workflow_arn   = string
    region         = optional(string)
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
      for w in var.workflow : w.on_failure == null || contains(["CONTINUE", "ABORT"], w.on_failure)
    ])
    error_message = "resource_aws_imagebuilder_image, on_failure must be one of CONTINUE or ABORT."
  }
  validation {
    condition = var.workflow == null || alltrue([
      for w in var.workflow : can(regex("^arn:aws[a-zA-Z-]*:imagebuilder:[a-z0-9-]+:[0-9]{12}:workflow/.+", w.workflow_arn))
    ])
    error_message = "resource_aws_imagebuilder_image, workflow_arn must be a valid ARN format for Image Builder Workflow."
  }
}

variable "tags" {
  description = "Key-value map of resource tags for the Image Builder Image."
  type        = map(string)
  default     = {}
}

variable "create_timeout" {
  description = "Timeout for creating the image."
  type        = string
  default     = "60m"
}