resource "aws_bedrockagent_prompt" "this" {
  name                        = var.name
  region                      = var.region
  description                 = var.description
  default_variant             = var.default_variant
  customer_encryption_key_arn = var.customer_encryption_key_arn
  tags                        = var.tags

  dynamic "variant" {
    for_each = var.variant
    content {
      name                            = variant.value.name
      model_id                        = variant.value.model_id
      template_type                   = variant.value.template_type
      additional_model_request_fields = variant.value.additional_model_request_fields

      dynamic "metadata" {
        for_each = variant.value.metadata != null ? variant.value.metadata : []
        content {
          key   = metadata.value.key
          value = metadata.value.value
        }
      }

      dynamic "inference_configuration" {
        for_each = variant.value.inference_configuration != null ? [variant.value.inference_configuration] : []
        content {
          dynamic "text" {
            for_each = inference_configuration.value.text != null ? [inference_configuration.value.text] : []
            content {
              max_tokens     = text.value.max_tokens
              stop_sequences = text.value.stop_sequences
              temperature    = text.value.temperature
              top_p          = text.value.top_p
            }
          }
        }
      }

      dynamic "gen_ai_resource" {
        for_each = variant.value.gen_ai_resource != null ? [variant.value.gen_ai_resource] : []
        content {
          dynamic "agent" {
            for_each = gen_ai_resource.value.agent != null ? [gen_ai_resource.value.agent] : []
            content {
              agent_identifier = agent.value.agent_identifier
            }
          }
        }
      }

      dynamic "template_configuration" {
        for_each = variant.value.template_configuration != null ? [variant.value.template_configuration] : []
        content {
          dynamic "text" {
            for_each = template_configuration.value.text != null ? [template_configuration.value.text] : []
            content {
              text = text.value.text

              dynamic "input_variable" {
                for_each = text.value.input_variable != null ? text.value.input_variable : []
                content {
                  name = input_variable.value.name
                }
              }

              dynamic "cache_point" {
                for_each = text.value.cache_point != null ? [text.value.cache_point] : []
                content {
                  type = cache_point.value.type
                }
              }
            }
          }

          dynamic "chat" {
            for_each = template_configuration.value.chat != null ? [template_configuration.value.chat] : []
            content {
              dynamic "input_variable" {
                for_each = chat.value.input_variable != null ? chat.value.input_variable : []
                content {
                  name = input_variable.value.name
                }
              }

              dynamic "message" {
                for_each = chat.value.message != null ? chat.value.message : []
                content {
                  role = message.value.role

                  dynamic "content" {
                    for_each = message.value.content != null ? [message.value.content] : []
                    content {
                      text = content.value.text

                      dynamic "cache_point" {
                        for_each = content.value.cache_point != null ? [content.value.cache_point] : []
                        content {
                          type = cache_point.value.type
                        }
                      }
                    }
                  }
                }
              }

              dynamic "system" {
                for_each = chat.value.system != null ? chat.value.system : []
                content {
                  text = system.value.text

                  dynamic "cache_point" {
                    for_each = system.value.cache_point != null ? [system.value.cache_point] : []
                    content {
                      type = cache_point.value.type
                    }
                  }
                }
              }

              dynamic "tool_configuration" {
                for_each = chat.value.tool_configuration != null ? [chat.value.tool_configuration] : []
                content {
                  dynamic "tool_choice" {
                    for_each = tool_configuration.value.tool_choice != null ? [tool_configuration.value.tool_choice] : []
                    content {
                      dynamic "any" {
                        for_each = tool_choice.value.any != null ? [tool_choice.value.any] : []
                        content {}
                      }

                      dynamic "auto" {
                        for_each = tool_choice.value.auto != null ? [tool_choice.value.auto] : []
                        content {}
                      }

                      dynamic "tool" {
                        for_each = tool_choice.value.tool != null ? [tool_choice.value.tool] : []
                        content {
                          name = tool.value.name
                        }
                      }
                    }
                  }

                  dynamic "tool" {
                    for_each = tool_configuration.value.tool != null ? tool_configuration.value.tool : []
                    content {
                      dynamic "cache_point" {
                        for_each = tool.value.cache_point != null ? [tool.value.cache_point] : []
                        content {
                          type = cache_point.value.type
                        }
                      }

                      dynamic "tool_spec" {
                        for_each = tool.value.tool_spec != null ? [tool.value.tool_spec] : []
                        content {
                          name        = tool_spec.value.name
                          description = tool_spec.value.description

                          dynamic "input_schema" {
                            for_each = tool_spec.value.input_schema != null ? [tool_spec.value.input_schema] : []
                            content {
                              json = input_schema.value.json
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}