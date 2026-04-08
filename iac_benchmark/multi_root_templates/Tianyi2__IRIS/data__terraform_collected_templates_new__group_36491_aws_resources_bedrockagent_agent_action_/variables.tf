variable "action_group_name" {
  description = "Name of the action group."
  type        = string
}

variable "agent_id" {
  description = "The unique identifier of the agent for which to create the action group."
  type        = string
}

variable "agent_version" {
  description = "Version of the agent for which to create the action group."
  type        = string
  validation {
    condition     = var.agent_version == "DRAFT"
    error_message = "resource_aws_bedrockagent_agent_action_group, agent_version must be 'DRAFT'."
  }
}

variable "action_group_executor" {
  description = "ARN of the Lambda function containing the business logic that is carried out upon invoking the action or custom control method for handling the information elicited from the user."
  type = object({
    custom_control = optional(string)
    lambda         = optional(string)
  })
  validation {
    condition = (
      (var.action_group_executor.custom_control != null && var.action_group_executor.lambda == null) ||
      (var.action_group_executor.custom_control == null && var.action_group_executor.lambda != null)
    )
    error_message = "resource_aws_bedrockagent_agent_action_group, action_group_executor must specify either custom_control or lambda, but not both."
  }
  validation {
    condition = (
      var.action_group_executor.custom_control == null ||
      var.action_group_executor.custom_control == "RETURN_CONTROL"
    )
    error_message = "resource_aws_bedrockagent_agent_action_group, action_group_executor custom_control must be 'RETURN_CONTROL'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "action_group_state" {
  description = "Whether the action group is available for the agent to invoke or not when sending an InvokeAgent request."
  type        = string
  default     = null
  validation {
    condition = (
      var.action_group_state == null ||
      contains(["ENABLED", "DISABLED"], var.action_group_state)
    )
    error_message = "resource_aws_bedrockagent_agent_action_group, action_group_state must be either 'ENABLED' or 'DISABLED'."
  }
}

variable "api_schema" {
  description = "Either details about the S3 object containing the OpenAPI schema for the action group or the JSON or YAML-formatted payload defining the schema."
  type = object({
    payload = optional(string)
    s3 = optional(object({
      s3_bucket_name = optional(string)
      s3_object_key  = optional(string)
    }))
  })
  default = null
  validation {
    condition = (
      var.api_schema == null ||
      (var.api_schema.payload != null && var.api_schema.s3 == null) ||
      (var.api_schema.payload == null && var.api_schema.s3 != null)
    )
    error_message = "resource_aws_bedrockagent_agent_action_group, api_schema must specify either payload or s3, but not both."
  }
}

variable "description" {
  description = "Description of the action group."
  type        = string
  default     = null
}

variable "function_schema" {
  description = "Describes the function schema for the action group. Each function represents an action in an action group."
  type = object({
    member_functions = optional(object({
      functions = optional(list(object({
        name        = string
        description = optional(string)
        parameters = optional(list(object({
          map_block_key = string
          type          = string
          description   = optional(string)
          required      = optional(bool)
        })))
      })))
    }))
  })
  default = null
  validation {
    condition = (
      var.function_schema == null ||
      var.function_schema.member_functions == null ||
      var.function_schema.member_functions.functions == null ||
      alltrue([
        for func in var.function_schema.member_functions.functions :
        func.parameters == null || alltrue([
          for param in func.parameters :
          contains(["string", "number", "integer", "boolean", "array"], param.type)
        ])
      ])
    )
    error_message = "resource_aws_bedrockagent_agent_action_group, function_schema parameter type must be one of: 'string', 'number', 'integer', 'boolean', 'array'."
  }
}

variable "parent_action_group_signature" {
  description = "To allow your agent to request the user for additional information when trying to complete a task, set this argument to AMAZON.UserInput."
  type        = string
  default     = null
  validation {
    condition = (
      var.parent_action_group_signature == null ||
      var.parent_action_group_signature == "AMAZON.UserInput"
    )
    error_message = "resource_aws_bedrockagent_agent_action_group, parent_action_group_signature must be 'AMAZON.UserInput'."
  }
}

variable "prepare_agent" {
  description = "Whether or not to prepare the agent after creation or modification."
  type        = bool
  default     = true
}

variable "skip_resource_in_use_check" {
  description = "Whether the in-use check is skipped when deleting the action group."
  type        = bool
  default     = null
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
  })
  default = {
    create = "30m"
    update = "30m"
  }
}