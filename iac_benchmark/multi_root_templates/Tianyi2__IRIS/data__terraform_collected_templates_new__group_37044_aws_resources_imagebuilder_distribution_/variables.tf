variable "name" {
  description = "Name of the distribution configuration"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9\\-_]*$", var.name))
    error_message = "resource_aws_imagebuilder_distribution_configuration, name must start with alphanumeric character and contain only alphanumeric characters, hyphens, and underscores."
  }

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 126
    error_message = "resource_aws_imagebuilder_distribution_configuration, name must be between 1 and 126 characters."
  }
}

variable "description" {
  description = "Description of the distribution configuration"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 1024
    error_message = "resource_aws_imagebuilder_distribution_configuration, description must be 1024 characters or less."
  }
}

variable "tags" {
  description = "Key-value map of resource tags for the distribution configuration"
  type        = map(string)
  default     = {}
}

variable "distribution" {
  description = "One or more configuration blocks with distribution settings"
  type = list(object({
    region                     = string
    license_configuration_arns = optional(set(string))

    ami_distribution_configuration = optional(object({
      ami_tags           = optional(map(string))
      description        = optional(string)
      kms_key_id         = optional(string)
      name               = optional(string)
      target_account_ids = optional(set(string))

      launch_permission = optional(object({
        organization_arns        = optional(set(string))
        organizational_unit_arns = optional(set(string))
        user_groups              = optional(set(string))
        user_ids                 = optional(set(string))
      }))
    }))

    container_distribution_configuration = optional(object({
      container_tags = optional(set(string))
      description    = optional(string)
      target_repository = object({
        repository_name = string
        service         = string
      })
    }))

    fast_launch_configuration = optional(list(object({
      account_id            = string
      enabled               = bool
      max_parallel_launches = optional(number)

      launch_template = optional(object({
        launch_template_id      = optional(string)
        launch_template_name    = optional(string)
        launch_template_version = optional(string)
      }))

      snapshot_configuration = optional(object({
        target_resource_count = optional(number)
      }))
    })))

    launch_template_configuration = optional(list(object({
      account_id         = optional(string)
      default            = optional(bool, true)
      launch_template_id = string
    })))

    s3_export_configuration = optional(list(object({
      disk_image_format = string
      role_name         = string
      s3_bucket         = string
      s3_prefix         = optional(string)
    })))

    ssm_parameter_configuration = optional(list(object({
      parameter_name = string
      ami_account_id = optional(string)
      data_type      = optional(string)
    })))
  }))

  validation {
    condition     = length(var.distribution) >= 1
    error_message = "resource_aws_imagebuilder_distribution_configuration, distribution must contain at least one distribution configuration."
  }

  validation {
    condition = alltrue([
      for dist in var.distribution : can(regex("^[a-z0-9-]+$", dist.region))
    ])
    error_message = "resource_aws_imagebuilder_distribution_configuration, distribution region must be a valid AWS region format."
  }

  validation {
    condition = alltrue([
      for dist in var.distribution :
      dist.ami_distribution_configuration == null ||
      dist.ami_distribution_configuration.description == null ||
      length(dist.ami_distribution_configuration.description) <= 1024
    ])
    error_message = "resource_aws_imagebuilder_distribution_configuration, distribution ami_distribution_configuration description must be 1024 characters or less."
  }

  validation {
    condition = alltrue([
      for dist in var.distribution :
      dist.ami_distribution_configuration == null ||
      dist.ami_distribution_configuration.name == null ||
      (length(dist.ami_distribution_configuration.name) >= 1 && length(dist.ami_distribution_configuration.name) <= 127)
    ])
    error_message = "resource_aws_imagebuilder_distribution_configuration, distribution ami_distribution_configuration name must be between 1 and 127 characters."
  }

  validation {
    condition = alltrue([
      for dist in var.distribution :
      dist.ami_distribution_configuration == null ||
      dist.ami_distribution_configuration.launch_permission == null ||
      dist.ami_distribution_configuration.launch_permission.user_groups == null ||
      alltrue([
        for group in dist.ami_distribution_configuration.launch_permission.user_groups :
        contains(["all"], group)
      ])
    ])
    error_message = "resource_aws_imagebuilder_distribution_configuration, distribution ami_distribution_configuration launch_permission user_groups must contain only 'all' if specified."
  }

  validation {
    condition = alltrue([
      for dist in var.distribution :
      dist.container_distribution_configuration == null ||
      dist.container_distribution_configuration.description == null ||
      length(dist.container_distribution_configuration.description) <= 1024
    ])
    error_message = "resource_aws_imagebuilder_distribution_configuration, distribution container_distribution_configuration description must be 1024 characters or less."
  }

  validation {
    condition = alltrue([
      for dist in var.distribution :
      dist.container_distribution_configuration == null ||
      contains(["ECR"], dist.container_distribution_configuration.target_repository.service)
    ])
    error_message = "resource_aws_imagebuilder_distribution_configuration, distribution container_distribution_configuration target_repository service must be 'ECR'."
  }

  validation {
    condition = alltrue([
      for dist in var.distribution :
      dist.fast_launch_configuration == null ||
      alltrue([
        for config in dist.fast_launch_configuration :
        can(regex("^[0-9]{12}$", config.account_id))
      ])
    ])
    error_message = "resource_aws_imagebuilder_distribution_configuration, distribution fast_launch_configuration account_id must be a valid 12-digit AWS account ID."
  }

  validation {
    condition = alltrue([
      for dist in var.distribution :
      dist.fast_launch_configuration == null ||
      alltrue([
        for config in dist.fast_launch_configuration :
        config.max_parallel_launches == null || (config.max_parallel_launches >= 1 && config.max_parallel_launches <= 10000)
      ])
    ])
    error_message = "resource_aws_imagebuilder_distribution_configuration, distribution fast_launch_configuration max_parallel_launches must be between 1 and 10000."
  }

  validation {
    condition = alltrue([
      for dist in var.distribution :
      dist.s3_export_configuration == null ||
      alltrue([
        for config in dist.s3_export_configuration :
        contains(["RAW", "VHD", "VMDK"], config.disk_image_format)
      ])
    ])
    error_message = "resource_aws_imagebuilder_distribution_configuration, distribution s3_export_configuration disk_image_format must be one of: RAW, VHD, VMDK."
  }

  validation {
    condition = alltrue([
      for dist in var.distribution :
      dist.ssm_parameter_configuration == null ||
      alltrue([
        for config in dist.ssm_parameter_configuration :
        config.data_type == null || contains(["text", "aws:ec2:image"], config.data_type)
      ])
    ])
    error_message = "resource_aws_imagebuilder_distribution_configuration, distribution ssm_parameter_configuration data_type must be either 'text' or 'aws:ec2:image'."
  }

  validation {
    condition = alltrue([
      for dist in var.distribution :
      dist.ssm_parameter_configuration == null ||
      alltrue([
        for config in dist.ssm_parameter_configuration :
        config.ami_account_id == null || can(regex("^[0-9]{12}$", config.ami_account_id))
      ])
    ])
    error_message = "resource_aws_imagebuilder_distribution_configuration, distribution ssm_parameter_configuration ami_account_id must be a valid 12-digit AWS account ID."
  }
}