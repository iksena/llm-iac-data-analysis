variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "A description of the work team."
  type        = string

  validation {
    condition     = length(var.description) > 0
    error_message = "resource_aws_sagemaker_workteam, description must be a non-empty string."
  }
}

variable "workforce_name" {
  description = "The name of the workforce."
  type        = string
  default     = null
}

variable "workteam_name" {
  description = "The name of the Workteam (must be unique)."
  type        = string

  validation {
    condition     = length(var.workteam_name) > 0
    error_message = "resource_aws_sagemaker_workteam, workteam_name must be a non-empty string."
  }
}

variable "member_definition" {
  description = "A list of Member Definitions that contains objects that identify the workers that make up the work team."
  type = list(object({
    cognito_member_definition = optional(object({
      client_id  = string
      user_pool  = string
      user_group = string
    }))
    oidc_member_definition = optional(object({
      groups = list(string)
    }))
  }))

  validation {
    condition     = length(var.member_definition) > 0
    error_message = "resource_aws_sagemaker_workteam, member_definition must contain at least one member definition."
  }

  validation {
    condition = alltrue([
      for md in var.member_definition :
      (md.cognito_member_definition != null && md.oidc_member_definition == null) ||
      (md.cognito_member_definition == null && md.oidc_member_definition != null)
    ])
    error_message = "resource_aws_sagemaker_workteam, member_definition each member must have either cognito_member_definition or oidc_member_definition, but not both."
  }

  validation {
    condition = alltrue([
      for md in var.member_definition :
      md.cognito_member_definition == null ? true :
      (md.cognito_member_definition.client_id != null &&
        md.cognito_member_definition.user_pool != null &&
      md.cognito_member_definition.user_group != null)
    ])
    error_message = "resource_aws_sagemaker_workteam, member_definition cognito_member_definition requires client_id, user_pool, and user_group."
  }

  validation {
    condition = alltrue([
      for md in var.member_definition :
      md.oidc_member_definition == null ? true :
      (md.oidc_member_definition.groups != null && length(md.oidc_member_definition.groups) > 0)
    ])
    error_message = "resource_aws_sagemaker_workteam, member_definition oidc_member_definition requires a non-empty list of groups."
  }
}

variable "notification_configuration" {
  description = "Configures notification of workers regarding available or expiring work items."
  type = object({
    notification_topic_arn = string
  })
  default = null

  validation {
    condition = var.notification_configuration == null ? true : (
      var.notification_configuration.notification_topic_arn != null &&
      length(var.notification_configuration.notification_topic_arn) > 0
    )
    error_message = "resource_aws_sagemaker_workteam, notification_configuration notification_topic_arn must be a non-empty string."
  }
}

variable "worker_access_configuration" {
  description = "Use this optional parameter to constrain access to an Amazon S3 resource based on the IP address using supported IAM global condition keys."
  type = object({
    s3_presign = object({
      iam_policy_constraints = object({
        source_ip     = optional(string)
        vpc_source_ip = optional(string)
      })
    })
  })
  default = null

  validation {
    condition = var.worker_access_configuration == null ? true : (
      var.worker_access_configuration.s3_presign != null &&
      var.worker_access_configuration.s3_presign.iam_policy_constraints != null
    )
    error_message = "resource_aws_sagemaker_workteam, worker_access_configuration s3_presign and iam_policy_constraints are required when worker_access_configuration is specified."
  }

  validation {
    condition = var.worker_access_configuration == null ? true : (
      var.worker_access_configuration.s3_presign.iam_policy_constraints.source_ip == null ? true :
      contains(["Enabled", "Disabled"], var.worker_access_configuration.s3_presign.iam_policy_constraints.source_ip)
    )
    error_message = "resource_aws_sagemaker_workteam, worker_access_configuration source_ip must be either 'Enabled' or 'Disabled'."
  }

  validation {
    condition = var.worker_access_configuration == null ? true : (
      var.worker_access_configuration.s3_presign.iam_policy_constraints.vpc_source_ip == null ? true :
      contains(["Enabled", "Disabled"], var.worker_access_configuration.s3_presign.iam_policy_constraints.vpc_source_ip)
    )
    error_message = "resource_aws_sagemaker_workteam, worker_access_configuration vpc_source_ip must be either 'Enabled' or 'Disabled'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}