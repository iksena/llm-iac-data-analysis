variable "name" {
  description = "The name of the fleet provisioning template"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9:_-]+$", var.name))
    error_message = "resource_aws_iot_provisioning_template, name must contain only alphanumeric characters, hyphens, underscores, and colons."
  }
}

variable "description" {
  description = "The description of the fleet provisioning template"
  type        = string
  default     = null
}

variable "enabled" {
  description = "True to enable the fleet provisioning template, otherwise false"
  type        = bool
  default     = true
}

variable "pre_provisioning_hook" {
  description = "Creates a pre-provisioning hook template"
  type = object({
    payload_version = optional(string, "2020-04-01")
    target_arn      = optional(string)
  })
  default = null

  validation {
    condition = var.pre_provisioning_hook == null || (
      var.pre_provisioning_hook.payload_version == null ||
      var.pre_provisioning_hook.payload_version == "2020-04-01"
    )
    error_message = "resource_aws_iot_provisioning_template, pre_provisioning_hook payload_version must be '2020-04-01' if specified."
  }

  validation {
    condition = var.pre_provisioning_hook == null || (
      var.pre_provisioning_hook.target_arn == null ||
      can(regex("^arn:aws[a-zA-Z-]*:lambda:[a-z0-9-]+:[0-9]{12}:function:[a-zA-Z0-9-_]+(:[$]LATEST|:[0-9]+)?$", var.pre_provisioning_hook.target_arn))
    )
    error_message = "resource_aws_iot_provisioning_template, pre_provisioning_hook target_arn must be a valid Lambda function ARN."
  }
}

variable "provisioning_role_arn" {
  description = "The role ARN for the role associated with the fleet provisioning template. This IoT role grants permission to provision a device"
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/.*", var.provisioning_role_arn))
    error_message = "resource_aws_iot_provisioning_template, provisioning_role_arn must be a valid IAM role ARN."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "template_body" {
  description = "The JSON formatted contents of the fleet provisioning template"
  type        = string

  validation {
    condition     = can(jsondecode(var.template_body))
    error_message = "resource_aws_iot_provisioning_template, template_body must be valid JSON."
  }
}

variable "type" {
  description = "The type you define in a provisioning template"
  type        = string
  default     = null
}