variable "name" {
  description = "Project's name."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9][A-Za-z0-9\\-_]{1,254}$", var.name))
    error_message = "resource_aws_codebuild_project, name must be between 2 and 255 characters and contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "description" {
  description = "Short description of the project."
  type        = string
  default     = null
}

variable "build_timeout" {
  description = "Number of minutes, from 5 to 2160 (36 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed. The default is 60 minutes."
  type        = number
  default     = null

  validation {
    condition     = var.build_timeout == null || (var.build_timeout >= 5 && var.build_timeout <= 2160)
    error_message = "resource_aws_codebuild_project, build_timeout must be between 5 and 2160 minutes."
  }
}

variable "queued_timeout" {
  description = "Number of minutes, from 5 to 480 (8 hours), a build is allowed to be queued before it times out. The default is 8 hours."
  type        = number
  default     = null

  validation {
    condition     = var.queued_timeout == null || (var.queued_timeout >= 5 && var.queued_timeout <= 480)
    error_message = "resource_aws_codebuild_project, queued_timeout must be between 5 and 480 minutes."
  }
}

variable "service_role" {
  description = "Amazon Resource Name (ARN) of the AWS Identity and Access Management (IAM) role that enables AWS CodeBuild to interact with dependent AWS services on behalf of the AWS account."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.service_role))
    error_message = "resource_aws_codebuild_project, service_role must be a valid IAM role ARN."
  }
}

variable "badge_enabled" {
  description = "Generates a publicly-accessible URL for the projects build badge. Available as badge_url attribute when enabled."
  type        = bool
  default     = null
}

variable "concurrent_build_limit" {
  description = "Specify a maximum number of concurrent builds for the project. The value specified must be greater than 0 and less than the account concurrent running builds limit."
  type        = number
  default     = null

  validation {
    condition     = var.concurrent_build_limit == null || var.concurrent_build_limit > 0
    error_message = "resource_aws_codebuild_project, concurrent_build_limit must be greater than 0."
  }
}

variable "encryption_key" {
  description = "AWS Key Management Service (AWS KMS) customer master key (CMK) to be used for encrypting the build project's build output artifacts."
  type        = string
  default     = null

  validation {
    condition     = var.encryption_key == null || can(regex("^(arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9-]+|alias/.+)$", var.encryption_key))
    error_message = "resource_aws_codebuild_project, encryption_key must be a valid KMS key ARN or alias."
  }
}

variable "project_visibility" {
  description = "Specifies the visibility of the project's builds. Possible values are: PUBLIC_READ and PRIVATE. Default value is PRIVATE."
  type        = string
  default     = null

  validation {
    condition     = var.project_visibility == null || contains(["PUBLIC_READ", "PRIVATE"], var.project_visibility)
    error_message = "resource_aws_codebuild_project, project_visibility must be either 'PUBLIC_READ' or 'PRIVATE'."
  }
}

variable "resource_access_role" {
  description = "The ARN of the IAM role that enables CodeBuild to access the CloudWatch Logs and Amazon S3 artifacts for the project's builds in order to display them publicly. Only applicable if project_visibility is PUBLIC_READ."
  type        = string
  default     = null

  validation {
    condition     = var.resource_access_role == null || can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.resource_access_role))
    error_message = "resource_aws_codebuild_project, resource_access_role must be a valid IAM role ARN."
  }
}

variable "source_version" {
  description = "Version of the build input to be built for this project. If not specified, the latest version is used."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "artifacts" {
  description = "Configuration block for artifacts."
  type = object({
    artifact_identifier    = optional(string)
    bucket_owner_access    = optional(string)
    encryption_disabled    = optional(bool)
    location               = optional(string)
    name                   = optional(string)
    namespace_type         = optional(string)
    override_artifact_name = optional(bool)
    packaging              = optional(string)
    path                   = optional(string)
    type                   = string
  })

  validation {
    condition     = contains(["CODEPIPELINE", "NO_ARTIFACTS", "S3"], var.artifacts.type)
    error_message = "resource_aws_codebuild_project, artifacts.type must be one of: CODEPIPELINE, NO_ARTIFACTS, S3."
  }

  validation {
    condition     = var.artifacts.bucket_owner_access == null || contains(["NONE", "READ_ONLY", "FULL"], var.artifacts.bucket_owner_access)
    error_message = "resource_aws_codebuild_project, artifacts.bucket_owner_access must be one of: NONE, READ_ONLY, FULL."
  }

  validation {
    condition     = var.artifacts.namespace_type == null || contains(["BUILD_ID", "NONE"], var.artifacts.namespace_type)
    error_message = "resource_aws_codebuild_project, artifacts.namespace_type must be one of: BUILD_ID, NONE."
  }

  validation {
    condition     = var.artifacts.packaging == null || contains(["NONE", "ZIP"], var.artifacts.packaging)
    error_message = "resource_aws_codebuild_project, artifacts.packaging must be one of: NONE, ZIP."
  }
}

variable "build_batch_config" {
  description = "Defines the batch build options for the project."
  type = object({
    combine_artifacts = optional(bool)
    service_role      = string
    timeout_in_mins   = optional(number)
    restrictions = optional(object({
      compute_types_allowed  = optional(list(string))
      maximum_builds_allowed = optional(number)
    }))
  })
  default = null

  validation {
    condition     = var.build_batch_config == null || can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.build_batch_config.service_role))
    error_message = "resource_aws_codebuild_project, build_batch_config.service_role must be a valid IAM role ARN."
  }
}

variable "cache" {
  description = "Configuration block for cache."
  type = object({
    location = optional(string)
    modes    = optional(list(string))
    type     = optional(string)
  })
  default = null

  validation {
    condition     = var.cache == null || var.cache.type == null || contains(["NO_CACHE", "LOCAL", "S3"], var.cache.type)
    error_message = "resource_aws_codebuild_project, cache.type must be one of: NO_CACHE, LOCAL, S3."
  }

  validation {
    condition     = var.cache == null || var.cache.modes == null || alltrue([for mode in var.cache.modes : contains(["LOCAL_SOURCE_CACHE", "LOCAL_DOCKER_LAYER_CACHE", "LOCAL_CUSTOM_CACHE"], mode)])
    error_message = "resource_aws_codebuild_project, cache.modes must contain only: LOCAL_SOURCE_CACHE, LOCAL_DOCKER_LAYER_CACHE, LOCAL_CUSTOM_CACHE."
  }
}

variable "environment" {
  description = "Configuration block for environment."
  type = object({
    certificate                 = optional(string)
    compute_type                = string
    image                       = string
    type                        = string
    image_pull_credentials_type = optional(string)
    privileged_mode             = optional(bool)
    docker_server = optional(object({
      compute_type       = string
      security_group_ids = optional(list(string))
    }))
    fleet = optional(object({
      fleet_arn = optional(string)
    }))
    environment_variables = optional(list(object({
      name  = string
      value = string
      type  = optional(string)
    })))
    registry_credential = optional(object({
      credential          = string
      credential_provider = string
    }))
  })

  validation {
    condition = contains([
      "BUILD_GENERAL1_SMALL", "BUILD_GENERAL1_MEDIUM", "BUILD_GENERAL1_LARGE",
      "BUILD_GENERAL1_XLARGE", "BUILD_GENERAL1_2XLARGE", "BUILD_LAMBDA_1GB",
      "BUILD_LAMBDA_2GB", "BUILD_LAMBDA_4GB", "BUILD_LAMBDA_8GB", "BUILD_LAMBDA_10GB"
    ], var.environment.compute_type)
    error_message = "resource_aws_codebuild_project, environment.compute_type must be one of the supported compute types."
  }

  validation {
    condition = contains([
      "WINDOWS_CONTAINER", "LINUX_CONTAINER", "LINUX_GPU_CONTAINER", "ARM_CONTAINER",
      "WINDOWS_SERVER_2019_CONTAINER", "WINDOWS_SERVER_2022_CONTAINER",
      "LINUX_LAMBDA_CONTAINER", "ARM_LAMBDA_CONTAINER", "LINUX_EC2", "ARM_EC2", "WINDOWS_EC2", "MAC_ARM"
    ], var.environment.type)
    error_message = "resource_aws_codebuild_project, environment.type must be one of the supported environment types."
  }

  validation {
    condition     = var.environment.image_pull_credentials_type == null || contains(["CODEBUILD", "SERVICE_ROLE"], var.environment.image_pull_credentials_type)
    error_message = "resource_aws_codebuild_project, environment.image_pull_credentials_type must be either 'CODEBUILD' or 'SERVICE_ROLE'."
  }

  validation {
    condition = var.environment.docker_server == null || contains([
      "BUILD_GENERAL1_SMALL", "BUILD_GENERAL1_MEDIUM", "BUILD_GENERAL1_LARGE",
      "BUILD_GENERAL1_XLARGE", "BUILD_GENERAL1_2XLARGE"
    ], var.environment.docker_server.compute_type)
    error_message = "resource_aws_codebuild_project, environment.docker_server.compute_type must be one of the supported compute types."
  }

  validation {
    condition = var.environment.environment_variables == null || alltrue([
      for env_var in var.environment.environment_variables :
      env_var.type == null || contains(["PARAMETER_STORE", "PLAINTEXT", "SECRETS_MANAGER"], env_var.type)
    ])
    error_message = "resource_aws_codebuild_project, environment.environment_variables.type must be one of: PARAMETER_STORE, PLAINTEXT, SECRETS_MANAGER."
  }

  validation {
    condition     = var.environment.registry_credential == null || var.environment.registry_credential.credential_provider == "SECRETS_MANAGER"
    error_message = "resource_aws_codebuild_project, environment.registry_credential.credential_provider must be 'SECRETS_MANAGER'."
  }
}

variable "file_system_locations" {
  description = "A set of file system locations to mount inside the build."
  type = list(object({
    identifier    = optional(string)
    location      = optional(string)
    mount_options = optional(string)
    mount_point   = optional(string)
    type          = optional(string)
  }))
  default = null

  validation {
    condition = var.file_system_locations == null || alltrue([
      for fsl in var.file_system_locations :
      fsl.type == null || fsl.type == "EFS"
    ])
    error_message = "resource_aws_codebuild_project, file_system_locations.type must be 'EFS'."
  }
}

variable "logs_config" {
  description = "Configuration block for logs."
  type = object({
    cloudwatch_logs = optional(object({
      group_name  = optional(string)
      status      = optional(string)
      stream_name = optional(string)
    }))
    s3_logs = optional(object({
      encryption_disabled = optional(bool)
      location            = optional(string)
      status              = optional(string)
      bucket_owner_access = optional(string)
    }))
  })
  default = null

  validation {
    condition     = var.logs_config == null || var.logs_config.cloudwatch_logs == null || var.logs_config.cloudwatch_logs.status == null || contains(["ENABLED", "DISABLED"], var.logs_config.cloudwatch_logs.status)
    error_message = "resource_aws_codebuild_project, logs_config.cloudwatch_logs.status must be either 'ENABLED' or 'DISABLED'."
  }

  validation {
    condition     = var.logs_config == null || var.logs_config.s3_logs == null || var.logs_config.s3_logs.status == null || contains(["ENABLED", "DISABLED"], var.logs_config.s3_logs.status)
    error_message = "resource_aws_codebuild_project, logs_config.s3_logs.status must be either 'ENABLED' or 'DISABLED'."
  }

  validation {
    condition     = var.logs_config == null || var.logs_config.s3_logs == null || var.logs_config.s3_logs.bucket_owner_access == null || contains(["NONE", "READ_ONLY", "FULL"], var.logs_config.s3_logs.bucket_owner_access)
    error_message = "resource_aws_codebuild_project, logs_config.s3_logs.bucket_owner_access must be one of: NONE, READ_ONLY, FULL."
  }
}

variable "secondary_artifacts" {
  description = "Configuration block for secondary artifacts."
  type = list(object({
    artifact_identifier    = string
    bucket_owner_access    = optional(string)
    encryption_disabled    = optional(bool)
    location               = optional(string)
    name                   = optional(string)
    namespace_type         = optional(string)
    override_artifact_name = optional(bool)
    packaging              = optional(string)
    path                   = optional(string)
    type                   = string
  }))
  default = null

  validation {
    condition = var.secondary_artifacts == null || alltrue([
      for artifact in var.secondary_artifacts :
      contains(["CODEPIPELINE", "NO_ARTIFACTS", "S3"], artifact.type)
    ])
    error_message = "resource_aws_codebuild_project, secondary_artifacts.type must be one of: CODEPIPELINE, NO_ARTIFACTS, S3."
  }

  validation {
    condition = var.secondary_artifacts == null || alltrue([
      for artifact in var.secondary_artifacts :
      artifact.bucket_owner_access == null || contains(["NONE", "READ_ONLY", "FULL"], artifact.bucket_owner_access)
    ])
    error_message = "resource_aws_codebuild_project, secondary_artifacts.bucket_owner_access must be one of: NONE, READ_ONLY, FULL."
  }

  validation {
    condition = var.secondary_artifacts == null || alltrue([
      for artifact in var.secondary_artifacts :
      artifact.namespace_type == null || contains(["BUILD_ID", "NONE"], artifact.namespace_type)
    ])
    error_message = "resource_aws_codebuild_project, secondary_artifacts.namespace_type must be one of: BUILD_ID, NONE."
  }

  validation {
    condition = var.secondary_artifacts == null || alltrue([
      for artifact in var.secondary_artifacts :
      artifact.packaging == null || contains(["NONE", "ZIP"], artifact.packaging)
    ])
    error_message = "resource_aws_codebuild_project, secondary_artifacts.packaging must be one of: NONE, ZIP."
  }
}

variable "secondary_sources" {
  description = "Configuration block for secondary sources."
  type = list(object({
    buildspec           = optional(string)
    git_clone_depth     = optional(number)
    insecure_ssl        = optional(bool)
    location            = optional(string)
    report_build_status = optional(bool)
    source_identifier   = string
    type                = string
    auth = optional(object({
      type     = string
      resource = string
    }))
    git_submodules_config = optional(object({
      fetch_submodules = bool
    }))
    build_status_config = optional(object({
      context    = optional(string)
      target_url = optional(string)
    }))
  }))
  default = null

  validation {
    condition = var.secondary_sources == null || alltrue([
      for source in var.secondary_sources :
      contains(["BITBUCKET", "CODECOMMIT", "CODEPIPELINE", "GITHUB", "GITHUB_ENTERPRISE", "GITLAB", "GITLAB_SELF_MANAGED", "NO_SOURCE", "S3"], source.type)
    ])
    error_message = "resource_aws_codebuild_project, secondary_sources.type must be one of the supported source types."
  }

  validation {
    condition = var.secondary_sources == null || alltrue([
      for source in var.secondary_sources :
      source.auth == null || contains(["CODECONNECTIONS", "SECRETS_MANAGER"], source.auth.type)
    ])
    error_message = "resource_aws_codebuild_project, secondary_sources.auth.type must be either 'CODECONNECTIONS' or 'SECRETS_MANAGER'."
  }
}

variable "secondary_source_version" {
  description = "Configuration block for secondary source version."
  type = list(object({
    source_identifier = string
    source_version    = string
  }))
  default = null
}

variable "source_config" {
  description = "Configuration block for source."
  type = object({
    buildspec           = optional(string)
    git_clone_depth     = optional(number)
    insecure_ssl        = optional(bool)
    location            = optional(string)
    report_build_status = optional(bool)
    type                = string
    auth = optional(object({
      type     = string
      resource = string
    }))
    git_submodules_config = optional(object({
      fetch_submodules = bool
    }))
    build_status_config = optional(object({
      context    = optional(string)
      target_url = optional(string)
    }))
  })

  validation {
    condition     = contains(["BITBUCKET", "CODECOMMIT", "CODEPIPELINE", "GITHUB", "GITHUB_ENTERPRISE", "GITLAB", "GITLAB_SELF_MANAGED", "NO_SOURCE", "S3"], var.source_config.type)
    error_message = "resource_aws_codebuild_project, source.type must be one of the supported source types."
  }

  validation {
    condition     = var.source_config.auth == null || contains(["CODECONNECTIONS", "SECRETS_MANAGER"], var.source_config.auth.type)
    error_message = "resource_aws_codebuild_project, source.auth.type must be either 'CODECONNECTIONS' or 'SECRETS_MANAGER'."
  }
}

variable "vpc_config" {
  description = "Configuration block for VPC settings."
  type = object({
    security_group_ids = list(string)
    subnets            = list(string)
    vpc_id             = string
  })
  default = null

  validation {
    condition     = var.vpc_config == null || can(regex("^vpc-[0-9a-f]{8,17}$", var.vpc_config.vpc_id))
    error_message = "resource_aws_codebuild_project, vpc_config.vpc_id must be a valid VPC ID."
  }

  validation {
    condition = var.vpc_config == null || alltrue([
      for subnet_id in var.vpc_config.subnets :
      can(regex("^subnet-[0-9a-f]{8,17}$", subnet_id))
    ])
    error_message = "resource_aws_codebuild_project, vpc_config.subnets must contain valid subnet IDs."
  }

  validation {
    condition = var.vpc_config == null || alltrue([
      for sg_id in var.vpc_config.security_group_ids :
      can(regex("^sg-[0-9a-f]{8,17}$", sg_id))
    ])
    error_message = "resource_aws_codebuild_project, vpc_config.security_group_ids must contain valid security group IDs."
  }
}