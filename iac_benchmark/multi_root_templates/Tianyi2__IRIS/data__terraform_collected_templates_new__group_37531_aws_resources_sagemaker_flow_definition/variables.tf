variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "flow_definition_name" {
  description = "The name of your flow definition"
  type        = string

  validation {
    condition     = length(var.flow_definition_name) > 0
    error_message = "resource_aws_sagemaker_flow_definition, flow_definition_name must be a non-empty string."
  }
}

variable "role_arn" {
  description = "The Amazon Resource Name (ARN) of the role needed to call other services on your behalf"
  type        = string

  validation {
    condition     = length(var.role_arn) > 0
    error_message = "resource_aws_sagemaker_flow_definition, role_arn must be a non-empty string."
  }

  validation {
    condition     = can(regex("^arn:aws.*:iam::", var.role_arn))
    error_message = "resource_aws_sagemaker_flow_definition, role_arn must be a valid IAM role ARN."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "human_loop_config" {
  description = "An object containing information about the tasks the human reviewers will perform"
  type = object({
    human_task_ui_arn                     = string
    task_availability_lifetime_in_seconds = number
    task_count                            = number
    task_description                      = string
    task_title                            = string
    workteam_arn                          = string
    task_keywords                         = optional(list(string))
    task_time_limit_in_seconds            = optional(number, 3600)
    public_workforce_task_price = optional(object({
      amount_in_usd = optional(object({
        cents                     = optional(number)
        dollars                   = optional(number)
        tenth_fractions_of_a_cent = optional(number)
      }))
    }))
  })

  validation {
    condition     = length(var.human_loop_config.human_task_ui_arn) > 0
    error_message = "resource_aws_sagemaker_flow_definition, human_task_ui_arn must be a non-empty string."
  }

  validation {
    condition     = can(regex("^arn:aws.*:sagemaker:.*:human-task-ui/", var.human_loop_config.human_task_ui_arn))
    error_message = "resource_aws_sagemaker_flow_definition, human_task_ui_arn must be a valid SageMaker human task UI ARN."
  }

  validation {
    condition     = var.human_loop_config.task_availability_lifetime_in_seconds >= 1 && var.human_loop_config.task_availability_lifetime_in_seconds <= 864000
    error_message = "resource_aws_sagemaker_flow_definition, task_availability_lifetime_in_seconds must be between 1 and 864000."
  }

  validation {
    condition     = var.human_loop_config.task_count >= 1 && var.human_loop_config.task_count <= 3
    error_message = "resource_aws_sagemaker_flow_definition, task_count must be between 1 and 3."
  }

  validation {
    condition     = length(var.human_loop_config.task_description) > 0
    error_message = "resource_aws_sagemaker_flow_definition, task_description must be a non-empty string."
  }

  validation {
    condition     = length(var.human_loop_config.task_title) > 0
    error_message = "resource_aws_sagemaker_flow_definition, task_title must be a non-empty string."
  }

  validation {
    condition     = length(var.human_loop_config.workteam_arn) > 0
    error_message = "resource_aws_sagemaker_flow_definition, workteam_arn must be a non-empty string."
  }

  validation {
    condition     = can(regex("^arn:aws.*:sagemaker:.*:workteam/", var.human_loop_config.workteam_arn))
    error_message = "resource_aws_sagemaker_flow_definition, workteam_arn must be a valid SageMaker workteam ARN."
  }

  validation {
    condition = var.human_loop_config.public_workforce_task_price != null ? (
      var.human_loop_config.public_workforce_task_price.amount_in_usd != null ? (
        (var.human_loop_config.public_workforce_task_price.amount_in_usd.cents == null || (var.human_loop_config.public_workforce_task_price.amount_in_usd.cents >= 0 && var.human_loop_config.public_workforce_task_price.amount_in_usd.cents <= 99)) &&
        (var.human_loop_config.public_workforce_task_price.amount_in_usd.dollars == null || (var.human_loop_config.public_workforce_task_price.amount_in_usd.dollars >= 0 && var.human_loop_config.public_workforce_task_price.amount_in_usd.dollars <= 2)) &&
        (var.human_loop_config.public_workforce_task_price.amount_in_usd.tenth_fractions_of_a_cent == null || (var.human_loop_config.public_workforce_task_price.amount_in_usd.tenth_fractions_of_a_cent >= 0 && var.human_loop_config.public_workforce_task_price.amount_in_usd.tenth_fractions_of_a_cent <= 9))
      ) : true
    ) : true
    error_message = "resource_aws_sagemaker_flow_definition, cents must be between 0 and 99, dollars must be between 0 and 2, tenth_fractions_of_a_cent must be between 0 and 9."
  }
}

variable "output_config" {
  description = "An object containing information about where the human review results will be uploaded"
  type = object({
    s3_output_path = string
    kms_key_id     = optional(string)
  })

  validation {
    condition     = length(var.output_config.s3_output_path) > 0
    error_message = "resource_aws_sagemaker_flow_definition, s3_output_path must be a non-empty string."
  }

  validation {
    condition     = can(regex("^s3://", var.output_config.s3_output_path))
    error_message = "resource_aws_sagemaker_flow_definition, s3_output_path must be a valid S3 URI starting with s3://."
  }
}

variable "human_loop_activation_config" {
  description = "An object containing information about the events that trigger a human workflow"
  type = object({
    human_loop_activation_conditions_config = object({
      human_loop_activation_conditions = string
    })
  })
  default = null

  validation {
    condition = var.human_loop_activation_config != null ? (
      length(var.human_loop_activation_config.human_loop_activation_conditions_config.human_loop_activation_conditions) > 0
    ) : true
    error_message = "resource_aws_sagemaker_flow_definition, human_loop_activation_conditions must be a non-empty string when human_loop_activation_config is specified."
  }

  validation {
    condition = var.human_loop_activation_config != null ? (
      can(jsondecode(var.human_loop_activation_config.human_loop_activation_conditions_config.human_loop_activation_conditions))
    ) : true
    error_message = "resource_aws_sagemaker_flow_definition, human_loop_activation_conditions must be valid JSON when human_loop_activation_config is specified."
  }
}

variable "human_loop_request_source" {
  description = "Container for configuring the source of human task requests"
  type = object({
    aws_managed_human_loop_request_source = string
  })
  default = null

  validation {
    condition = var.human_loop_request_source != null ? (
      contains(["AWS/Rekognition/DetectModerationLabels/Image/V3", "AWS/Textract/AnalyzeDocument/Forms/V1"], var.human_loop_request_source.aws_managed_human_loop_request_source)
    ) : true
    error_message = "resource_aws_sagemaker_flow_definition, aws_managed_human_loop_request_source must be one of: AWS/Rekognition/DetectModerationLabels/Image/V3, AWS/Textract/AnalyzeDocument/Forms/V1."
  }
}