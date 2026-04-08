variable "name" {
  description = "The name of the container recipe."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][-a-zA-Z0-9_]*$", var.name))
    error_message = "resource_aws_imagebuilder_container_recipe, name must start with a letter and can contain letters, numbers, hyphens, and underscores."
  }
}

variable "recipe_version" {
  description = "Version of the container recipe."
  type        = string

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.recipe_version))
    error_message = "resource_aws_imagebuilder_container_recipe, recipe_version must follow semantic versioning format (e.g., 1.0.0)."
  }
}

variable "container_type" {
  description = "The type of the container to create."
  type        = string

  validation {
    condition     = contains(["DOCKER"], var.container_type)
    error_message = "resource_aws_imagebuilder_container_recipe, container_type must be DOCKER."
  }
}

variable "parent_image" {
  description = "The base image for the container recipe."
  type        = string

  validation {
    condition     = length(var.parent_image) > 0
    error_message = "resource_aws_imagebuilder_container_recipe, parent_image cannot be empty."
  }
}

variable "target_repository" {
  description = "The destination repository for the container image."
  type = object({
    repository_name = string
    service         = string
  })

  validation {
    condition     = contains(["ECR"], var.target_repository.service)
    error_message = "resource_aws_imagebuilder_container_recipe, target_repository service must be ECR."
  }

  validation {
    condition     = length(var.target_repository.repository_name) > 0
    error_message = "resource_aws_imagebuilder_container_recipe, target_repository repository_name cannot be empty."
  }
}

variable "components" {
  description = "Ordered configuration block(s) with components for the container recipe."
  type = list(object({
    component_arn = string
    parameters = optional(list(object({
      name  = string
      value = string
    })))
  }))

  validation {
    condition     = length(var.components) > 0
    error_message = "resource_aws_imagebuilder_container_recipe, components must contain at least one component."
  }

  validation {
    condition = alltrue([
      for component in var.components : can(regex("^arn:aws:imagebuilder:", component.component_arn))
    ])
    error_message = "resource_aws_imagebuilder_container_recipe, components component_arn must be a valid Image Builder component ARN."
  }
}

variable "description" {
  description = "The description of the container recipe."
  type        = string
  default     = null
}

variable "dockerfile_template_data" {
  description = "The Dockerfile template used to build the image as an inline data blob."
  type        = string
  default     = null
}

variable "dockerfile_template_uri" {
  description = "The Amazon S3 URI for the Dockerfile that will be used to build the container image."
  type        = string
  default     = null

  validation {
    condition     = var.dockerfile_template_uri == null || can(regex("^s3://", var.dockerfile_template_uri))
    error_message = "resource_aws_imagebuilder_container_recipe, dockerfile_template_uri must be a valid S3 URI starting with s3://."
  }
}

variable "instance_configuration" {
  description = "Configuration block used to configure an instance for building and testing container images."
  type = object({
    image = optional(string)
    block_device_mappings = optional(list(object({
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
    })))
  })
  default = null
}

variable "kms_key_id" {
  description = "The KMS key used to encrypt the container image."
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_id == null || can(regex("^(arn:aws:kms:|[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})", var.kms_key_id))
    error_message = "resource_aws_imagebuilder_container_recipe, kms_key_id must be a valid KMS key ARN or key ID."
  }
}

variable "platform_override" {
  description = "Specifies the operating system platform when you use a custom base image."
  type        = string
  default     = null

  validation {
    condition     = var.platform_override == null || contains(["Windows", "Linux"], var.platform_override)
    error_message = "resource_aws_imagebuilder_container_recipe, platform_override must be either Windows or Linux."
  }
}

variable "tags" {
  description = "Key-value map of resource tags for the container recipe."
  type        = map(string)
  default     = {}
}

variable "working_directory" {
  description = "The working directory to be used during build and test workflows."
  type        = string
  default     = null

  validation {
    condition     = var.working_directory == null || can(regex("^/", var.working_directory))
    error_message = "resource_aws_imagebuilder_container_recipe, working_directory must be an absolute path starting with /."
  }
}