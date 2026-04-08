variable "portal_arn" {
  description = "ARN of the web portal"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:workspaces-web:[^:]+:[^:]+:portal/.+$", var.portal_arn))
    error_message = "resource_aws_workspacesweb_session_logger_association, portal_arn must be a valid WorkSpaces Web portal ARN."
  }
}

variable "session_logger_arn" {
  description = "ARN of the session logger"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:workspaces-web:[^:]+:[^:]+:sessionLogger/.+$", var.session_logger_arn))
    error_message = "resource_aws_workspacesweb_session_logger_association, session_logger_arn must be a valid WorkSpaces Web session logger ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_workspacesweb_session_logger_association, region must be a valid AWS region identifier or null."
  }
}