variable "action_names" {
  description = "A set of IAM action names to run simulations for. Each entry in this set adds an additional hypothetical request to the simulation."
  type        = set(string)

  validation {
    condition     = length(var.action_names) > 0
    error_message = "data_aws_iam_principal_policy_simulation, action_names must contain at least one IAM action name."
  }

  validation {
    condition = alltrue([
      for action in var.action_names : can(regex("^[a-z0-9-]+:[a-zA-Z0-9*]+$", action))
    ])
    error_message = "data_aws_iam_principal_policy_simulation, action_names must contain valid IAM action names in the format 'service:action'."
  }
}

variable "policy_source_arn" {
  description = "The ARN of the IAM user, group, or role whose policies will be included in the simulation."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:(user|group|role)/.+$", var.policy_source_arn))
    error_message = "data_aws_iam_principal_policy_simulation, policy_source_arn must be a valid IAM user, group, or role ARN."
  }
}

variable "caller_arn" {
  description = "The ARN of an user that will appear as the 'caller' of the simulated requests. If you do not specify caller_arn then the simulation will use the policy_source_arn instead, if it contains a user ARN."
  type        = string
  default     = null

  validation {
    condition     = var.caller_arn == null || can(regex("^arn:aws:iam::[0-9]{12}:user/.+$", var.caller_arn))
    error_message = "data_aws_iam_principal_policy_simulation, caller_arn must be a valid IAM user ARN when specified."
  }
}

variable "context" {
  description = "Each context block defines an entry in the table of additional context keys in the simulated request."
  type = list(object({
    key    = string
    type   = string
    values = set(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for ctx in var.context : ctx.key != null && ctx.key != ""
    ])
    error_message = "data_aws_iam_principal_policy_simulation, context key cannot be null or empty."
  }

  validation {
    condition = alltrue([
      for ctx in var.context : contains([
        "string", "stringList", "numeric", "numericList", "boolean", "booleanList",
        "ip", "ipList", "date", "dateList", "binary", "binaryList"
      ], ctx.type)
    ])
    error_message = "data_aws_iam_principal_policy_simulation, context type must be one of: string, stringList, numeric, numericList, boolean, booleanList, ip, ipList, date, dateList, binary, binaryList."
  }

  validation {
    condition = alltrue([
      for ctx in var.context : length(ctx.values) > 0
    ])
    error_message = "data_aws_iam_principal_policy_simulation, context values must contain at least one value."
  }
}

variable "additional_policies_json" {
  description = "A set of additional principal policy documents to include in the simulation. The simulator will behave as if each of these policies were associated with the object specified in policy_source_arn, allowing you to test the effect of hypothetical policies not yet created."
  type        = set(string)
  default     = null

  validation {
    condition = var.additional_policies_json == null || alltrue([
      for policy in var.additional_policies_json : can(jsondecode(policy))
    ])
    error_message = "data_aws_iam_principal_policy_simulation, additional_policies_json must contain valid JSON policy documents."
  }
}

variable "permissions_boundary_policies_json" {
  description = "A set of permissions boundary policy documents to include in the simulation."
  type        = set(string)
  default     = null

  validation {
    condition = var.permissions_boundary_policies_json == null || alltrue([
      for policy in var.permissions_boundary_policies_json : can(jsondecode(policy))
    ])
    error_message = "data_aws_iam_principal_policy_simulation, permissions_boundary_policies_json must contain valid JSON policy documents."
  }
}

variable "resource_arns" {
  description = "A set of ARNs of resources to include in the simulation. This argument is important for actions that have either required or optional resource types."
  type        = set(string)
  default     = null

  validation {
    condition = var.resource_arns == null || alltrue([
      for arn in var.resource_arns : can(regex("^arn:aws:[a-z0-9-]+:[a-z0-9-]*:[0-9]*:.*$", arn))
    ])
    error_message = "data_aws_iam_principal_policy_simulation, resource_arns must contain valid AWS ARNs."
  }
}

variable "resource_handling_option" {
  description = "Specifies a special simulation type to run. Some EC2 actions require special simulation behaviors and a particular set of resource ARNs to achieve a realistic result."
  type        = string
  default     = null

  validation {
    condition = var.resource_handling_option == null || contains([
      "UseResourceArn", "UseStaticResource"
    ], var.resource_handling_option)
    error_message = "data_aws_iam_principal_policy_simulation, resource_handling_option must be either 'UseResourceArn' or 'UseStaticResource' when specified."
  }
}

variable "resource_owner_account_id" {
  description = "An AWS account ID to use for any resource ARN in resource_arns that doesn't include its own AWS account ID. If unspecified, the simulator will use the account ID from the caller_arn argument as a placeholder."
  type        = string
  default     = null

  validation {
    condition     = var.resource_owner_account_id == null || can(regex("^[0-9]{12}$", var.resource_owner_account_id))
    error_message = "data_aws_iam_principal_policy_simulation, resource_owner_account_id must be a valid 12-digit AWS account ID when specified."
  }
}

variable "resource_policy_json" {
  description = "An IAM policy document representing the resource-level policy of all of the resources specified in resource_arns. The policy simulator cannot automatically load policies that are associated with individual resources."
  type        = string
  default     = null

  validation {
    condition     = var.resource_policy_json == null || can(jsondecode(var.resource_policy_json))
    error_message = "data_aws_iam_principal_policy_simulation, resource_policy_json must be a valid JSON policy document when specified."
  }
}