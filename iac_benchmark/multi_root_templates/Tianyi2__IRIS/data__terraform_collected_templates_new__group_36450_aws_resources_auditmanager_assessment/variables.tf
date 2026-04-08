variable "name" {
  description = "Name of the assessment"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_auditmanager_assessment, name must not be empty."
  }
}

variable "description" {
  description = "Description of the assessment"
  type        = string
  default     = null
}

variable "framework_id" {
  description = "Unique identifier of the framework the assessment will be created from"
  type        = string

  validation {
    condition     = length(var.framework_id) > 0
    error_message = "resource_aws_auditmanager_assessment, framework_id must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the assessment"
  type        = map(string)
  default     = {}
}

variable "assessment_reports_destination" {
  description = "Assessment report storage destination configuration"
  type = object({
    destination      = string
    destination_type = string
  })

  validation {
    condition     = length(var.assessment_reports_destination.destination) > 0
    error_message = "resource_aws_auditmanager_assessment, assessment_reports_destination.destination must not be empty."
  }

  validation {
    condition     = startswith(var.assessment_reports_destination.destination, "s3://")
    error_message = "resource_aws_auditmanager_assessment, assessment_reports_destination.destination must be in the form s3://{bucket_name}."
  }

  validation {
    condition     = var.assessment_reports_destination.destination_type == "S3"
    error_message = "resource_aws_auditmanager_assessment, assessment_reports_destination.destination_type must be 'S3'."
  }
}

variable "roles" {
  description = "List of roles for the assessment"
  type = list(object({
    role_arn  = string
    role_type = string
  }))

  validation {
    condition     = length(var.roles) > 0
    error_message = "resource_aws_auditmanager_assessment, roles must contain at least one role."
  }

  validation {
    condition = alltrue([
      for role in var.roles : length(role.role_arn) > 0
    ])
    error_message = "resource_aws_auditmanager_assessment, roles.role_arn must not be empty for all roles."
  }

  validation {
    condition = alltrue([
      for role in var.roles : startswith(role.role_arn, "arn:aws:iam::")
    ])
    error_message = "resource_aws_auditmanager_assessment, roles.role_arn must be a valid IAM role ARN."
  }

  validation {
    condition = alltrue([
      for role in var.roles : role.role_type == "PROCESS_OWNER"
    ])
    error_message = "resource_aws_auditmanager_assessment, roles.role_type must be 'PROCESS_OWNER'."
  }
}

variable "scope" {
  description = "Amazon Web Services accounts and services that are in scope for the assessment"
  type = object({
    aws_accounts = optional(list(object({
      id = string
    })))
    aws_services = optional(list(object({
      service_name = string
    })))
  })

  validation {
    condition     = var.scope.aws_accounts != null || var.scope.aws_services != null
    error_message = "resource_aws_auditmanager_assessment, scope must contain at least one of aws_accounts or aws_services."
  }

  validation {
    condition = var.scope.aws_accounts != null ? alltrue([
      for account in var.scope.aws_accounts : length(account.id) > 0
    ]) : true
    error_message = "resource_aws_auditmanager_assessment, scope.aws_accounts.id must not be empty for all accounts."
  }

  validation {
    condition = var.scope.aws_accounts != null ? alltrue([
      for account in var.scope.aws_accounts : can(regex("^[0-9]{12}$", account.id))
    ]) : true
    error_message = "resource_aws_auditmanager_assessment, scope.aws_accounts.id must be a valid 12-digit AWS account ID."
  }

  validation {
    condition = var.scope.aws_services != null ? alltrue([
      for service in var.scope.aws_services : length(service.service_name) > 0
    ]) : true
    error_message = "resource_aws_auditmanager_assessment, scope.aws_services.service_name must not be empty for all services."
  }
}