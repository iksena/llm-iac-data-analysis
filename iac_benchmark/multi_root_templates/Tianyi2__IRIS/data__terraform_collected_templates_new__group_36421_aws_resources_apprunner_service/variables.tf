variable "service_name" {
  description = "Name of the service"
  type        = string

  validation {
    condition     = length(var.service_name) > 0
    error_message = "resource_aws_apprunner_service, service_name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "auto_scaling_configuration_arn" {
  description = "ARN of an App Runner automatic scaling configuration resource that you want to associate with your service"
  type        = string
  default     = null
}

variable "source_configuration" {
  description = "The source to deploy to the App Runner service. Can be a code or an image repository"
  type = object({
    auto_deployments_enabled = optional(bool, true)
    authentication_configuration = optional(object({
      access_role_arn = optional(string)
      connection_arn  = optional(string)
    }))
    code_repository = optional(object({
      repository_url   = string
      source_directory = optional(string)
      source_code_version = object({
        type  = string
        value = string
      })
      code_configuration = optional(object({
        configuration_source = string
        code_configuration_values = optional(object({
          build_command                 = optional(string)
          port                          = optional(string, "8080")
          runtime                       = string
          runtime_environment_secrets   = optional(map(string))
          runtime_environment_variables = optional(map(string))
          start_command                 = optional(string)
        }))
      }))
    }))
    image_repository = optional(object({
      image_identifier      = string
      image_repository_type = string
      image_configuration = optional(object({
        port                          = optional(string, "8080")
        runtime_environment_secrets   = optional(map(string))
        runtime_environment_variables = optional(map(string))
        start_command                 = optional(string)
      }))
    }))
  })

  validation {
    condition     = var.source_configuration.code_repository != null || var.source_configuration.image_repository != null
    error_message = "resource_aws_apprunner_service, source_configuration must specify either code_repository or image_repository."
  }

  validation {
    condition     = !(var.source_configuration.code_repository != null && var.source_configuration.image_repository != null)
    error_message = "resource_aws_apprunner_service, source_configuration cannot specify both code_repository and image_repository."
  }

  validation {
    condition     = var.source_configuration.code_repository == null || contains(["BRANCH"], var.source_configuration.code_repository.source_code_version.type)
    error_message = "resource_aws_apprunner_service, source_configuration.code_repository.source_code_version.type must be BRANCH."
  }

  validation {
    condition     = var.source_configuration.code_repository == null || var.source_configuration.code_repository.code_configuration == null || contains(["REPOSITORY", "API"], var.source_configuration.code_repository.code_configuration.configuration_source)
    error_message = "resource_aws_apprunner_service, source_configuration.code_repository.code_configuration.configuration_source must be REPOSITORY or API."
  }

  validation {
    condition     = var.source_configuration.code_repository == null || var.source_configuration.code_repository.code_configuration == null || var.source_configuration.code_repository.code_configuration.code_configuration_values == null || contains(["PYTHON_3", "NODEJS_12", "NODEJS_14", "NODEJS_16", "CORRETTO_8", "CORRETTO_11", "GO_1", "DOTNET_6", "PHP_81", "RUBY_31"], var.source_configuration.code_repository.code_configuration.code_configuration_values.runtime)
    error_message = "resource_aws_apprunner_service, source_configuration.code_repository.code_configuration.code_configuration_values.runtime must be one of: PYTHON_3, NODEJS_12, NODEJS_14, NODEJS_16, CORRETTO_8, CORRETTO_11, GO_1, DOTNET_6, PHP_81, RUBY_31."
  }

  validation {
    condition     = var.source_configuration.image_repository == null || contains(["ECR", "ECR_PUBLIC"], var.source_configuration.image_repository.image_repository_type)
    error_message = "resource_aws_apprunner_service, source_configuration.image_repository.image_repository_type must be ECR or ECR_PUBLIC."
  }
}

variable "encryption_configuration" {
  description = "An optional custom encryption key that App Runner uses to encrypt the copy of your source repository that it maintains and your service logs"
  type = object({
    kms_key = string
  })
  default = null

  validation {
    condition     = var.encryption_configuration == null || length(var.encryption_configuration.kms_key) > 0
    error_message = "resource_aws_apprunner_service, encryption_configuration.kms_key must not be empty."
  }
}

variable "health_check_configuration" {
  description = "Settings of the health check that AWS App Runner performs to monitor the health of your service"
  type = object({
    healthy_threshold   = optional(number, 1)
    interval            = optional(number, 5)
    path                = optional(string, "/")
    protocol            = optional(string, "TCP")
    timeout             = optional(number, 2)
    unhealthy_threshold = optional(number, 5)
  })
  default = null

  validation {
    condition     = var.health_check_configuration == null || (var.health_check_configuration.healthy_threshold >= 1 && var.health_check_configuration.healthy_threshold <= 20)
    error_message = "resource_aws_apprunner_service, health_check_configuration.healthy_threshold must be between 1 and 20."
  }

  validation {
    condition     = var.health_check_configuration == null || (var.health_check_configuration.interval >= 1 && var.health_check_configuration.interval <= 20)
    error_message = "resource_aws_apprunner_service, health_check_configuration.interval must be between 1 and 20."
  }

  validation {
    condition     = var.health_check_configuration == null || length(var.health_check_configuration.path) <= 51200
    error_message = "resource_aws_apprunner_service, health_check_configuration.path must not exceed 51200 characters."
  }

  validation {
    condition     = var.health_check_configuration == null || contains(["TCP", "HTTP"], var.health_check_configuration.protocol)
    error_message = "resource_aws_apprunner_service, health_check_configuration.protocol must be TCP or HTTP."
  }

  validation {
    condition     = var.health_check_configuration == null || (var.health_check_configuration.timeout >= 1 && var.health_check_configuration.timeout <= 20)
    error_message = "resource_aws_apprunner_service, health_check_configuration.timeout must be between 1 and 20."
  }

  validation {
    condition     = var.health_check_configuration == null || (var.health_check_configuration.unhealthy_threshold >= 1 && var.health_check_configuration.unhealthy_threshold <= 20)
    error_message = "resource_aws_apprunner_service, health_check_configuration.unhealthy_threshold must be between 1 and 20."
  }
}

variable "instance_configuration" {
  description = "The runtime configuration of instances (scaling units) of the App Runner service"
  type = object({
    cpu               = optional(string, "1024")
    instance_role_arn = optional(string)
    memory            = optional(string, "2048")
  })
  default = null

  validation {
    condition     = var.instance_configuration == null || contains(["256", "512", "1024", "2048", "4096", "0.25 vCPU", "0.5 vCPU", "1 vCPU", "2 vCPU", "4 vCPU"], var.instance_configuration.cpu)
    error_message = "resource_aws_apprunner_service, instance_configuration.cpu must be one of: 256, 512, 1024, 2048, 4096, 0.25 vCPU, 0.5 vCPU, 1 vCPU, 2 vCPU, 4 vCPU."
  }

  validation {
    condition     = var.instance_configuration == null || contains(["512", "1024", "2048", "3072", "4096", "6144", "8192", "10240", "12288", "0.5 GB", "1 GB", "2 GB", "3 GB", "4 GB", "6 GB", "8 GB", "10 GB", "12 GB"], var.instance_configuration.memory)
    error_message = "resource_aws_apprunner_service, instance_configuration.memory must be one of: 512, 1024, 2048, 3072, 4096, 6144, 8192, 10240, 12288, 0.5 GB, 1 GB, 2 GB, 3 GB, 4 GB, 6 GB, 8 GB, 10 GB, 12 GB."
  }
}

variable "network_configuration" {
  description = "Configuration settings related to network traffic of the web application that the App Runner service runs"
  type = object({
    ip_address_type = optional(string, "IPV4")
    ingress_configuration = optional(object({
      is_publicly_accessible = bool
    }))
    egress_configuration = optional(object({
      egress_type       = string
      vpc_connector_arn = optional(string)
    }))
  })
  default = null

  validation {
    condition     = var.network_configuration == null || contains(["IPV4", "DUAL_STACK"], var.network_configuration.ip_address_type)
    error_message = "resource_aws_apprunner_service, network_configuration.ip_address_type must be IPV4 or DUAL_STACK."
  }

  validation {
    condition     = var.network_configuration == null || var.network_configuration.egress_configuration == null || contains(["DEFAULT", "VPC"], var.network_configuration.egress_configuration.egress_type)
    error_message = "resource_aws_apprunner_service, network_configuration.egress_configuration.egress_type must be DEFAULT or VPC."
  }
}

variable "observability_configuration" {
  description = "The observability configuration of your service"
  type = object({
    observability_enabled           = bool
    observability_configuration_arn = optional(string)
  })
  default = null
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : !startswith(k, "AWSAPPRUNNER")
    ])
    error_message = "resource_aws_apprunner_service, tags cannot have keys starting with AWSAPPRUNNER."
  }
}