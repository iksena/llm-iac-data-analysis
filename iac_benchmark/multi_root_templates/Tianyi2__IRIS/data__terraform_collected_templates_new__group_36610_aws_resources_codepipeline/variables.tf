variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the pipeline"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_codepipeline, name must not be empty."
  }
}

variable "pipeline_type" {
  description = "Type of the pipeline. Possible values are: V1 and V2. Default value is V1"
  type        = string
  default     = "V1"

  validation {
    condition     = contains(["V1", "V2"], var.pipeline_type)
    error_message = "resource_aws_codepipeline, pipeline_type must be either V1 or V2."
  }
}

variable "role_arn" {
  description = "A service role Amazon Resource Name (ARN) that grants AWS CodePipeline permission to make calls to AWS services on your behalf"
  type        = string

  validation {
    condition     = length(var.role_arn) > 0 && can(regex("^arn:aws:iam::", var.role_arn))
    error_message = "resource_aws_codepipeline, role_arn must be a valid IAM role ARN."
  }
}

variable "artifact_store" {
  description = "One or more artifact_store blocks"
  type = list(object({
    location = string
    type     = string
    region   = optional(string)
    encryption_key = optional(object({
      id   = string
      type = string
    }))
  }))

  validation {
    condition     = length(var.artifact_store) > 0
    error_message = "resource_aws_codepipeline, artifact_store must contain at least one artifact store."
  }

  validation {
    condition = alltrue([
      for store in var.artifact_store : contains(["S3"], store.type)
    ])
    error_message = "resource_aws_codepipeline, artifact_store type must be S3."
  }

  validation {
    condition = alltrue([
      for store in var.artifact_store : store.encryption_key == null || contains(["KMS"], store.encryption_key.type)
    ])
    error_message = "resource_aws_codepipeline, artifact_store encryption_key type must be KMS."
  }
}

variable "execution_mode" {
  description = "The method that the pipeline will use to handle multiple executions. The default mode is SUPERSEDED"
  type        = string
  default     = "SUPERSEDED"

  validation {
    condition     = contains(["SUPERSEDED", "QUEUED", "PARALLEL"], var.execution_mode)
    error_message = "resource_aws_codepipeline, execution_mode must be one of SUPERSEDED, QUEUED, or PARALLEL."
  }
}

variable "stage" {
  description = "A stage block. Minimum of at least two stage blocks is required"
  type = list(object({
    name = string
    action = list(object({
      category         = string
      owner            = string
      name             = string
      provider         = string
      version          = string
      configuration    = optional(map(string))
      input_artifacts  = optional(list(string))
      output_artifacts = optional(list(string))
      role_arn         = optional(string)
      run_order        = optional(number)
      region           = optional(string)
      namespace        = optional(string)
    }))
    before_entry = optional(object({
      condition = list(object({
        result = optional(string)
        rule = optional(list(object({
          name               = string
          commands           = optional(list(string))
          configuration      = optional(map(string))
          input_artifacts    = optional(list(string))
          region             = optional(string)
          role_arn           = optional(string)
          timeout_in_minutes = optional(number)
          rule_type_id = object({
            category = string
            provider = string
            owner    = optional(string)
            version  = optional(string)
          })
        })))
      }))
    }))
    on_success = optional(object({
      condition = list(object({
        result = optional(string)
        rule = optional(list(object({
          name               = string
          commands           = optional(list(string))
          configuration      = optional(map(string))
          input_artifacts    = optional(list(string))
          region             = optional(string)
          role_arn           = optional(string)
          timeout_in_minutes = optional(number)
          rule_type_id = object({
            category = string
            provider = string
            owner    = optional(string)
            version  = optional(string)
          })
        })))
      }))
    }))
    on_failure = optional(object({
      result = optional(string)
      condition = optional(object({
        result = optional(string)
        rule = optional(list(object({
          name               = string
          commands           = optional(list(string))
          configuration      = optional(map(string))
          input_artifacts    = optional(list(string))
          region             = optional(string)
          role_arn           = optional(string)
          timeout_in_minutes = optional(number)
          rule_type_id = object({
            category = string
            provider = string
            owner    = optional(string)
            version  = optional(string)
          })
        })))
      }))
      retry_configuration = optional(object({
        retry_mode = optional(string)
      }))
    }))
  }))

  validation {
    condition     = length(var.stage) >= 2
    error_message = "resource_aws_codepipeline, stage must contain at least two stages."
  }

  validation {
    condition = alltrue([
      for stage in var.stage : length(stage.action) > 0
    ])
    error_message = "resource_aws_codepipeline, stage must contain at least one action."
  }

  validation {
    condition = alltrue([
      for stage in var.stage : alltrue([
        for action in stage.action : contains(["Approval", "Build", "Deploy", "Invoke", "Source", "Test"], action.category)
      ])
    ])
    error_message = "resource_aws_codepipeline, stage action category must be one of Approval, Build, Deploy, Invoke, Source, or Test."
  }

  validation {
    condition = alltrue([
      for stage in var.stage : alltrue([
        for action in stage.action : contains(["AWS", "Custom", "ThirdParty"], action.owner)
      ])
    ])
    error_message = "resource_aws_codepipeline, stage action owner must be one of AWS, Custom, or ThirdParty."
  }

  validation {
    condition = alltrue([
      for stage in var.stage : stage.on_failure == null || stage.on_failure.result == null || contains(["ROLLBACK", "FAIL", "RETRY", "SKIP"], stage.on_failure.result)
    ])
    error_message = "resource_aws_codepipeline, stage on_failure result must be one of ROLLBACK, FAIL, RETRY, or SKIP."
  }

  validation {
    condition = alltrue([
      for stage in var.stage : stage.on_failure == null || stage.on_failure.retry_configuration == null || stage.on_failure.retry_configuration.retry_mode == null || contains(["FAILED_ACTIONS", "ALL_ACTIONS"], stage.on_failure.retry_configuration.retry_mode)
    ])
    error_message = "resource_aws_codepipeline, stage on_failure retry_configuration retry_mode must be one of FAILED_ACTIONS or ALL_ACTIONS."
  }
}

variable "trigger" {
  description = "A trigger block. Valid only when pipeline_type is V2"
  type = list(object({
    provider_type = string
    git_configuration = object({
      source_action_name = string
      pull_request = optional(object({
        events = optional(list(string))
        branches = optional(object({
          includes = optional(list(string))
          excludes = optional(list(string))
        }))
        file_paths = optional(object({
          includes = optional(list(string))
          excludes = optional(list(string))
        }))
      }))
      push = optional(object({
        branches = optional(object({
          includes = optional(list(string))
          excludes = optional(list(string))
        }))
        file_paths = optional(object({
          includes = optional(list(string))
          excludes = optional(list(string))
        }))
        tags = optional(object({
          includes = optional(list(string))
          excludes = optional(list(string))
        }))
      }))
    })
  }))
  default = []

  validation {
    condition = alltrue([
      for trigger in var.trigger : contains(["CodeStarSourceConnection"], trigger.provider_type)
    ])
    error_message = "resource_aws_codepipeline, trigger provider_type must be CodeStarSourceConnection."
  }

  validation {
    condition = alltrue([
      for trigger in var.trigger : trigger.git_configuration.pull_request == null || trigger.git_configuration.pull_request.events == null || alltrue([
        for event in trigger.git_configuration.pull_request.events : contains(["OPEN", "UPDATED", "CLOSED"], event)
      ])
    ])
    error_message = "resource_aws_codepipeline, trigger git_configuration pull_request events must be one of OPEN, UPDATED, or CLOSED."
  }
}

variable "variable" {
  description = "A pipeline-level variable block. Valid only when pipeline_type is V2"
  type = list(object({
    name          = string
    default_value = optional(string)
    description   = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for variable in var.variable : length(variable.name) > 0
    ])
    error_message = "resource_aws_codepipeline, variable name must not be empty."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}