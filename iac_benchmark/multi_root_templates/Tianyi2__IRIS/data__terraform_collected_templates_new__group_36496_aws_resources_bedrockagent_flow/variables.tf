variable "name" {
  description = "A name for the flow."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.name))
    error_message = "resource_aws_bedrockagent_flow, name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "execution_role_arn" {
  description = "The Amazon Resource Name (ARN) of the service role with permissions to create and manage a flow."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.execution_role_arn))
    error_message = "resource_aws_bedrockagent_flow, execution_role_arn must be a valid IAM role ARN."
  }
}

variable "description" {
  description = "A description for the flow."
  type        = string
  default     = null
}

variable "customer_encryption_key_arn" {
  description = "The Amazon Resource Name (ARN) of the KMS key to encrypt the flow."
  type        = string
  default     = null

  validation {
    condition     = var.customer_encryption_key_arn == null || can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9-]+$", var.customer_encryption_key_arn))
    error_message = "resource_aws_bedrockagent_flow, customer_encryption_key_arn must be a valid KMS key ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_bedrockagent_flow, region must be a valid AWS region name."
  }
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}

variable "definition" {
  description = "A definition of the nodes and connections between nodes in the flow."
  type = object({
    connection = optional(list(object({
      name   = string
      source = string
      target = string
      type   = string
      configuration = object({
        data = optional(object({
          source_output = string
          target_input  = string
        }))
        conditional = optional(object({
          condition = string
        }))
      })
    })))
    node = optional(list(object({
      name = string
      type = string
      input = optional(list(object({
        name       = string
        type       = string
        expression = string
        category   = optional(string)
      })))
      output = optional(list(object({
        name = string
        type = string
      })))
      configuration = object({
        agent = optional(object({
          agent_alias_arn = string
        }))
        collector = optional(object({}))
        condition = optional(object({
          condition = optional(list(object({
            name       = string
            expression = optional(string)
          })))
        }))
        inline_code = optional(object({
          code     = string
          language = string
        }))
        input    = optional(object({}))
        iterator = optional(object({}))
        knowledge_base = optional(object({
          knowledge_base_id = string
          model_id          = string
          guardrail_configuration = object({
            guardrail_identifier = string
            guardrail_version    = string
          })
        }))
        lambda_function = optional(object({
          lambda_arn = string
        }))
        lex = optional(object({
          bot_alias_arn = string
          locale_id     = string
        }))
        output = optional(object({}))
        prompt = optional(object({
          source_configuration = object({
            resource = optional(object({
              prompt_arn = string
            }))
            inline = optional(object({
              additional_model_request_fields = optional(string)
              model_id                        = string
              template_type                   = string
              inference_configuration = optional(object({
                text = optional(object({
                  max_tokens     = optional(number)
                  stop_sequences = optional(list(string))
                  temperature    = optional(number)
                  top_p          = optional(number)
                }))
              }))
              template_configuration = object({
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
                    content = object({
                      text = optional(string)
                      cache_point = optional(object({
                        type = string
                      }))
                    })
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
              })
            }))
          })
        }))
        retrieval = optional(object({
          service_configuration = object({
            s3 = optional(object({
              bucket_name = string
            }))
          })
        }))
        storage = optional(object({
          service_configuration = object({
            s3 = optional(object({
              bucket_name = string
            }))
          })
        }))
      })
    })))
  })
  default = null

  validation {
    condition = var.definition == null || (
      var.definition.connection == null ||
      alltrue([
        for conn in var.definition.connection : contains(["Data", "Conditional"], conn.type)
      ])
    )
    error_message = "resource_aws_bedrockagent_flow, definition connection type must be either 'Data' or 'Conditional'."
  }

  validation {
    condition = var.definition == null || (
      var.definition.node == null ||
      alltrue([
        for node in var.definition.node : contains([
          "Agent", "Collector", "Condition", "Input", "Iterator",
          "KnowledgeBase", "LambdaFunction", "Lex", "Output",
          "Prompt", "Retrieval", "Storage"
        ], node.type)
      ])
    )
    error_message = "resource_aws_bedrockagent_flow, definition node type must be one of: Agent, Collector, Condition, Input, Iterator, KnowledgeBase, LambdaFunction, Lex, Output, Prompt, Retrieval, Storage."
  }

  validation {
    condition = var.definition == null || (
      var.definition.node == null ||
      alltrue([
        for node in var.definition.node :
        node.configuration.prompt == null || (
          node.configuration.prompt.source_configuration.inline == null ||
          contains(["TEXT", "CHAT"], node.configuration.prompt.source_configuration.inline.template_type)
        )
      ])
    )
    error_message = "resource_aws_bedrockagent_flow, definition node prompt template_type must be either 'TEXT' or 'CHAT'."
  }

  validation {
    condition = var.definition == null || (
      var.definition.node == null ||
      alltrue([
        for node in var.definition.node :
        node.configuration.prompt == null || (
          node.configuration.prompt.source_configuration.inline == null ||
          node.configuration.prompt.source_configuration.inline.template_configuration.text == null ||
          node.configuration.prompt.source_configuration.inline.template_configuration.text.cache_point == null ||
          contains(["default"], node.configuration.prompt.source_configuration.inline.template_configuration.text.cache_point.type)
        )
      ])
    )
    error_message = "resource_aws_bedrockagent_flow, definition node prompt cache_point type must be 'default'."
  }

  validation {
    condition = var.definition == null || (
      var.definition.node == null ||
      alltrue([
        for node in var.definition.node :
        node.configuration.agent == null || can(regex("^arn:aws:bedrock:[a-z0-9-]+:[0-9]{12}:agent-alias/[A-Z0-9]{10}/[A-Z0-9]{10}$", node.configuration.agent.agent_alias_arn))
      ])
    )
    error_message = "resource_aws_bedrockagent_flow, definition node agent agent_alias_arn must be a valid agent alias ARN."
  }

  validation {
    condition = var.definition == null || (
      var.definition.node == null ||
      alltrue([
        for node in var.definition.node :
        node.configuration.lambda_function == null || can(regex("^arn:aws:lambda:[a-z0-9-]+:[0-9]{12}:function:[a-zA-Z0-9-_]+", node.configuration.lambda_function.lambda_arn))
      ])
    )
    error_message = "resource_aws_bedrockagent_flow, definition node lambda_function lambda_arn must be a valid Lambda function ARN."
  }

  validation {
    condition = var.definition == null || (
      var.definition.node == null ||
      alltrue([
        for node in var.definition.node :
        node.configuration.lex == null || can(regex("^arn:aws:lex:[a-z0-9-]+:[0-9]{12}:bot-alias/[A-Z0-9]{10}/[A-Z0-9]{10}$", node.configuration.lex.bot_alias_arn))
      ])
    )
    error_message = "resource_aws_bedrockagent_flow, definition node lex bot_alias_arn must be a valid Lex bot alias ARN."
  }

  validation {
    condition = var.definition == null || (
      var.definition.node == null ||
      alltrue([
        for node in var.definition.node :
        node.configuration.prompt == null || (
          node.configuration.prompt.source_configuration.resource == null ||
          can(regex("^arn:aws:bedrock:[a-z0-9-]+:[0-9]{12}:prompt/[A-Z0-9]{10}$", node.configuration.prompt.source_configuration.resource.prompt_arn))
        )
      ])
    )
    error_message = "resource_aws_bedrockagent_flow, definition node prompt resource prompt_arn must be a valid prompt ARN."
  }

  validation {
    condition = var.definition == null || (
      var.definition.node == null ||
      alltrue([
        for node in var.definition.node :
        node.configuration.prompt == null || (
          node.configuration.prompt.source_configuration.inline == null ||
          node.configuration.prompt.source_configuration.inline.inference_configuration == null ||
          node.configuration.prompt.source_configuration.inline.inference_configuration.text == null ||
          node.configuration.prompt.source_configuration.inline.inference_configuration.text.temperature == null ||
          (node.configuration.prompt.source_configuration.inline.inference_configuration.text.temperature >= 0 && node.configuration.prompt.source_configuration.inline.inference_configuration.text.temperature <= 1)
        )
      ])
    )
    error_message = "resource_aws_bedrockagent_flow, definition node prompt inference_configuration text temperature must be between 0 and 1."
  }

  validation {
    condition = var.definition == null || (
      var.definition.node == null ||
      alltrue([
        for node in var.definition.node :
        node.configuration.prompt == null || (
          node.configuration.prompt.source_configuration.inline == null ||
          node.configuration.prompt.source_configuration.inline.inference_configuration == null ||
          node.configuration.prompt.source_configuration.inline.inference_configuration.text == null ||
          node.configuration.prompt.source_configuration.inline.inference_configuration.text.top_p == null ||
          (node.configuration.prompt.source_configuration.inline.inference_configuration.text.top_p >= 0 && node.configuration.prompt.source_configuration.inline.inference_configuration.text.top_p <= 1)
        )
      ])
    )
    error_message = "resource_aws_bedrockagent_flow, definition node prompt inference_configuration text top_p must be between 0 and 1."
  }

  validation {
    condition = var.definition == null || (
      var.definition.node == null ||
      alltrue([
        for node in var.definition.node :
        node.configuration.prompt == null || (
          node.configuration.prompt.source_configuration.inline == null ||
          node.configuration.prompt.source_configuration.inline.inference_configuration == null ||
          node.configuration.prompt.source_configuration.inline.inference_configuration.text == null ||
          node.configuration.prompt.source_configuration.inline.inference_configuration.text.max_tokens == null ||
          node.configuration.prompt.source_configuration.inline.inference_configuration.text.max_tokens > 0
        )
      ])
    )
    error_message = "resource_aws_bedrockagent_flow, definition node prompt inference_configuration text max_tokens must be greater than 0."
  }
}