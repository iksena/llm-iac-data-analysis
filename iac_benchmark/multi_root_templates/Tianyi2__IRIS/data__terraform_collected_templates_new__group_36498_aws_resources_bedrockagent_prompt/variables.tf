variable "name" {
  description = "Name of the prompt."
  type        = string
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the prompt."
  type        = string
  default     = null
}

variable "default_variant" {
  description = "Name of the default variant for your prompt."
  type        = string
  default     = null
}

variable "customer_encryption_key_arn" {
  description = "Amazon Resource Name (ARN) of the KMS key that you encrypted the prompt with."
  type        = string
  default     = null
}

variable "variant" {
  description = "A list of objects, each containing details about a variant of the prompt."
  type = list(object({
    name                            = string
    model_id                        = optional(string)
    template_type                   = string
    additional_model_request_fields = optional(string)
    metadata = optional(list(object({
      key   = string
      value = string
    })))
    inference_configuration = optional(object({
      text = optional(object({
        max_tokens     = optional(number)
        stop_sequences = optional(list(string))
        temperature    = optional(number)
        top_p          = optional(number)
      }))
    }))
    gen_ai_resource = optional(object({
      agent = optional(object({
        agent_identifier = string
      }))
    }))
    template_configuration = optional(object({
      text = optional(object({
        text = string
        input_variable = optional(list(object({
          name = string
        })))
        cache_point = optional(object({
          type = string
        }))
      }))
      chat = optional(object({
        input_variable = optional(list(object({
          name = string
        })))
        message = optional(list(object({
          role = string
          content = optional(object({
            text = optional(string)
            cache_point = optional(object({
              type = string
            }))
          }))
        })))
        system = optional(list(object({
          text = optional(string)
          cache_point = optional(object({
            type = string
          }))
        })))
        tool_configuration = optional(object({
          tool_choice = optional(object({
            any  = optional(object({}))
            auto = optional(object({}))
            tool = optional(object({
              name = string
            }))
          }))
          tool = optional(list(object({
            cache_point = optional(object({
              type = string
            }))
            tool_spec = optional(object({
              name        = string
              description = optional(string)
              input_schema = optional(object({
                json = optional(string)
              }))
            }))
          })))
        }))
      }))
    }))
  }))
  default = []

  validation {
    condition = alltrue([
      for v in var.variant : contains(["CHAT", "TEXT"], v.template_type)
    ])
    error_message = "resource_aws_bedrockagent_prompt, template_type must be one of: CHAT, TEXT."
  }

  validation {
    condition = alltrue([
      for v in var.variant : v.model_id != null || v.gen_ai_resource != null
    ])
    error_message = "resource_aws_bedrockagent_prompt, either model_id or gen_ai_resource must be specified for each variant."
  }

  validation {
    condition = alltrue([
      for v in var.variant :
      v.template_configuration != null ? (
        v.template_configuration.text != null ?
        v.template_configuration.text.cache_point != null ?
        contains(["default"], v.template_configuration.text.cache_point.type) : true
        : true
      ) : true
    ])
    error_message = "resource_aws_bedrockagent_prompt, cache_point type must be 'default'."
  }

  validation {
    condition = alltrue([
      for v in var.variant :
      v.template_configuration != null ? (
        v.template_configuration.chat != null ?
        v.template_configuration.chat.system != null ?
        alltrue([
          for s in v.template_configuration.chat.system :
          s.cache_point != null ? contains(["default"], s.cache_point.type) : true
        ]) : true
        : true
      ) : true
    ])
    error_message = "resource_aws_bedrockagent_prompt, system cache_point type must be 'default'."
  }

  validation {
    condition = alltrue([
      for v in var.variant :
      v.template_configuration != null ? (
        v.template_configuration.chat != null ?
        v.template_configuration.chat.message != null ?
        alltrue([
          for m in v.template_configuration.chat.message :
          m.content != null ? (
            m.content.cache_point != null ? contains(["default"], m.content.cache_point.type) : true
          ) : true
        ]) : true
        : true
      ) : true
    ])
    error_message = "resource_aws_bedrockagent_prompt, message content cache_point type must be 'default'."
  }

  validation {
    condition = alltrue([
      for v in var.variant :
      v.template_configuration != null ? (
        v.template_configuration.chat != null ?
        v.template_configuration.chat.tool_configuration != null ?
        v.template_configuration.chat.tool_configuration.tool != null ?
        alltrue([
          for t in v.template_configuration.chat.tool_configuration.tool :
          t.cache_point != null ? contains(["default"], t.cache_point.type) : true
        ]) : true
        : true
        : true
      ) : true
    ])
    error_message = "resource_aws_bedrockagent_prompt, tool cache_point type must be 'default'."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}