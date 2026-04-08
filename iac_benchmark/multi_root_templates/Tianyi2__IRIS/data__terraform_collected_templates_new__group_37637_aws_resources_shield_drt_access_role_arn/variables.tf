variable "role_arn" {
  description = "The Amazon Resource Name (ARN) of the role the SRT will use to access your AWS account. Prior to making the AssociateDRTRole request, you must attach the AWSShieldDRTAccessPolicy managed policy to this role."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/.+", var.role_arn))
    error_message = "resource_aws_shield_drt_access_role_arn_association, role_arn must be a valid IAM role ARN in the format arn:aws:iam::account-id:role/role-name."
  }
}

variable "timeouts" {
  description = "Timeout configuration for the resource operations"
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {}

  validation {
    condition = alltrue([
      can(regex("^[0-9]+[smh]$", var.timeouts.create)),
      can(regex("^[0-9]+[smh]$", var.timeouts.update)),
      can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    ])
    error_message = "resource_aws_shield_drt_access_role_arn_association, timeouts must be in the format of number followed by s (seconds), m (minutes), or h (hours)."
  }
}