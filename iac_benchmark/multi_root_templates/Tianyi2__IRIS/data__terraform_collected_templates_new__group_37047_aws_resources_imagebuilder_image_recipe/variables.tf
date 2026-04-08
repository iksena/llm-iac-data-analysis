variable "component" {
  description = "Ordered configuration block(s) with components for the image recipe"
  type = list(object({
    component_arn = string
    parameter = optional(list(object({
      name  = string
      value = string
    })), [])
  }))

  validation {
    condition     = length(var.component) > 0
    error_message = "resource_aws_imagebuilder_image_recipe, component must contain at least one component."
  }

  validation {
    condition = alltrue([
      for comp in var.component : comp.component_arn != null && comp.component_arn != ""
    ])
    error_message = "resource_aws_imagebuilder_image_recipe, component_arn must be specified for all components."
  }

  validation {
    condition = alltrue([
      for comp in var.component : alltrue([
        for param in comp.parameter : param.name != null && param.name != "" && param.value != null
      ])
    ])
    error_message = "resource_aws_imagebuilder_image_recipe, component parameter name and value must be specified."
  }
}

variable "name" {
  description = "Name of the image recipe"
  type        = string

  validation {
    condition     = var.name != null && var.name != ""
    error_message = "resource_aws_imagebuilder_image_recipe, name must be specified and cannot be empty."
  }
}

variable "parent_image" {
  description = "The image recipe uses this image as a base from which to build your customized image. The value can be the base image ARN or an AMI ID"
  type        = string

  validation {
    condition     = var.parent_image != null && var.parent_image != ""
    error_message = "resource_aws_imagebuilder_image_recipe, parent_image must be specified and cannot be empty."
  }
}

variable "recipe_version" {
  description = "The semantic version of the image recipe, which specifies the version in the following format, with numeric values in each position to indicate a specific version: major.minor.patch. For example: 1.0.0"
  type        = string

  validation {
    condition     = var.recipe_version != null && var.recipe_version != ""
    error_message = "resource_aws_imagebuilder_image_recipe, recipe_version must be specified and cannot be empty."
  }

  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+$", var.recipe_version))
    error_message = "resource_aws_imagebuilder_image_recipe, recipe_version must follow semantic versioning format (major.minor.patch)."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "block_device_mapping" {
  description = "Configuration block(s) with block device mappings for the image recipe"
  type = list(object({
    device_name  = optional(string)
    no_device    = optional(bool)
    virtual_name = optional(string)
    ebs = optional(object({
      delete_on_termination = optional(bool)
      encrypted             = optional(bool)
      iops                  = optional(number)
      kms_key_id            = optional(string)
      snapshot_id           = optional(string)
      throughput            = optional(number)
      volume_size           = optional(number)
      volume_type           = optional(string)
    }))
  }))
  default = []

  validation {
    condition = alltrue([
      for bdm in var.block_device_mapping : (
        (bdm.ebs != null && bdm.ebs.volume_type != null && contains(["gp2", "gp3", "io1", "io2", "sc1", "st1", "standard"], bdm.ebs.volume_type)) ||
        bdm.ebs == null ||
        bdm.ebs.volume_type == null
      )
    ])
    error_message = "resource_aws_imagebuilder_image_recipe, block_device_mapping ebs volume_type must be one of: gp2, gp3, io1, io2, sc1, st1, standard."
  }

  validation {
    condition = alltrue([
      for bdm in var.block_device_mapping : (
        (bdm.ebs != null && bdm.ebs.iops != null && bdm.ebs.volume_type != null && contains(["io1", "io2", "gp3"], bdm.ebs.volume_type)) ||
        bdm.ebs == null ||
        bdm.ebs.iops == null
      )
    ])
    error_message = "resource_aws_imagebuilder_image_recipe, block_device_mapping ebs iops can only be specified for io1, io2, and gp3 volume types."
  }

  validation {
    condition = alltrue([
      for bdm in var.block_device_mapping : (
        (bdm.ebs != null && bdm.ebs.throughput != null && bdm.ebs.volume_type == "gp3") ||
        bdm.ebs == null ||
        bdm.ebs.throughput == null
      )
    ])
    error_message = "resource_aws_imagebuilder_image_recipe, block_device_mapping ebs throughput can only be specified for gp3 volume types."
  }
}

variable "description" {
  description = "Description of the image recipe"
  type        = string
  default     = null
}

variable "systems_manager_agent" {
  description = "Configuration block for the Systems Manager Agent installed by default by Image Builder"
  type = object({
    uninstall_after_build = bool
  })
  default = null

  validation {
    condition     = var.systems_manager_agent == null || var.systems_manager_agent.uninstall_after_build != null
    error_message = "resource_aws_imagebuilder_image_recipe, systems_manager_agent uninstall_after_build must be specified when systems_manager_agent is configured."
  }
}

variable "tags" {
  description = "Key-value map of resource tags for the image recipe"
  type        = map(string)
  default     = {}
}

variable "user_data_base64" {
  description = "Base64 encoded user data. Use this to provide commands or a command script to run when you launch your build instance"
  type        = string
  default     = null

  validation {
    condition     = var.user_data_base64 == null || can(base64decode(var.user_data_base64))
    error_message = "resource_aws_imagebuilder_image_recipe, user_data_base64 must be valid base64 encoded data."
  }
}

variable "working_directory" {
  description = "The working directory to be used during build and test workflows"
  type        = string
  default     = null
}