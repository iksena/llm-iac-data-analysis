resource "aws_bedrockagent_flow" "this" {
  name                        = var.name
  execution_role_arn          = var.execution_role_arn
  description                 = var.description
  customer_encryption_key_arn = var.customer_encryption_key_arn
  region                      = var.region
  tags                        = var.tags

  dynamic "definition" {
    for_each = var.definition != null ? [var.definition] : []
    content {
      dynamic "connection" {
        for_each = definition.value.connection != null ? definition.value.connection : []
        content {
          name   = connection.value.name
          source = connection.value.source
          target = connection.value.target
          type   = connection.value.type

          dynamic "configuration" {
            for_each = connection.value.configuration != null ? [connection.value.configuration] : []
            content {
              dynamic "data" {
                for_each = configuration.value.data != null ? [configuration.value.data] : []
                content {
                  source_output = data.value.source_output
                  target_input  = data.value.target_input
                }
              }

              dynamic "conditional" {
                for_each = configuration.value.conditional != null ? [configuration.value.conditional] : []
                content {
                  condition = conditional.value.condition
                }
              }
            }
          }
        }
      }

      dynamic "node" {
        for_each = definition.value.node != null ? definition.value.node : []
        content {
          name = node.value.name
          type = node.value.type

          dynamic "input" {
            for_each = node.value.input != null ? node.value.input : []
            content {
              name       = input.value.name
              type       = input.value.type
              expression = input.value.expression
              category   = input.value.category
            }
          }

          dynamic "output" {
            for_each = node.value.output != null ? node.value.output : []
            content {
              name = output.value.name
              type = output.value.type
            }
          }

          dynamic "configuration" {
            for_each = node.value.configuration != null ? [node.value.configuration] : []
            content {
              dynamic "agent" {
                for_each = configuration.value.agent != null ? [configuration.value.agent] : []
                content {
                  agent_alias_arn = agent.value.agent_alias_arn
                }
              }

              dynamic "collector" {
                for_each = configuration.value.collector != null ? [configuration.value.collector] : []
                content {}
              }

              dynamic "condition" {
                for_each = configuration.value.condition != null ? [configuration.value.condition] : []
                content {
                  dynamic "condition" {
                    for_each = condition.value.condition != null ? condition.value.condition : []
                    content {
                      name       = condition.value.name
                      expression = condition.value.expression
                    }
                  }
                }
              }

              dynamic "inline_code" {
                for_each = configuration.value.inline_code != null ? [configuration.value.inline_code] : []
                content {
                  code     = inline_code.value.code
                  language = inline_code.value.language
                }
              }

              dynamic "input" {
                for_each = configuration.value.input != null ? [configuration.value.input] : []
                content {}
              }

              dynamic "iterator" {
                for_each = configuration.value.iterator != null ? [configuration.value.iterator] : []
                content {}
              }

              dynamic "knowledge_base" {
                for_each = configuration.value.knowledge_base != null ? [configuration.value.knowledge_base] : []
                content {
                  knowledge_base_id = knowledge_base.value.knowledge_base_id
                  model_id          = knowledge_base.value.model_id

                  dynamic "guardrail_configuration" {
                    for_each = knowledge_base.value.guardrail_configuration != null ? [knowledge_base.value.guardrail_configuration] : []
                    content {
                      guardrail_identifier = guardrail_configuration.value.guardrail_identifier
                      guardrail_version    = guardrail_configuration.value.guardrail_version
                    }
                  }
                }
              }

              dynamic "lambda_function" {
                for_each = configuration.value.lambda_function != null ? [configuration.value.lambda_function] : []
                content {
                  lambda_arn = lambda_function.value.lambda_arn
                }
              }

              dynamic "lex" {
                for_each = configuration.value.lex != null ? [configuration.value.lex] : []
                content {
                  bot_alias_arn = lex.value.bot_alias_arn
                  locale_id     = lex.value.locale_id
                }
              }

              dynamic "output" {
                for_each = configuration.value.output != null ? [configuration.value.output] : []
                content {}
              }

              dynamic "prompt" {
                for_each = configuration.value.prompt != null ? [configuration.value.prompt] : []
                content {
                  dynamic "source_configuration" {
                    for_each = prompt.value.source_configuration != null ? [prompt.value.source_configuration] : []
                    content {
                      dynamic "resource" {
                        for_each = source_configuration.value.resource != null ? [source_configuration.value.resource] : []
                        content {
                          prompt_arn = resource.value.prompt_arn
                        }
                      }

                      dynamic "inline" {
                        for_each = source_configuration.value.inline != null ? [source_configuration.value.inline] : []
                        content {
                          additional_model_request_fields = inline.value.additional_model_request_fields
                          model_id                        = inline.value.model_id
                          template_type                   = inline.value.template_type

                          dynamic "inference_configuration" {
                            for_each = inline.value.inference_configuration != null ? [inline.value.inference_configuration] : []
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

                          dynamic "template_configuration" {
                            for_each = inline.value.template_configuration != null ? [inline.value.template_configuration] : []
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
                  }
                }
              }

              dynamic "retrieval" {
                for_each = configuration.value.retrieval != null ? [configuration.value.retrieval] : []
                content {
                  dynamic "service_configuration" {
                    for_each = retrieval.value.service_configuration != null ? [retrieval.value.service_configuration] : []
                    content {
                      dynamic "s3" {
                        for_each = service_configuration.value.s3 != null ? [service_configuration.value.s3] : []
                        content {
                          bucket_name = s3.value.bucket_name
                        }
                      }
                    }
                  }
                }
              }

              dynamic "storage" {
                for_each = configuration.value.storage != null ? [configuration.value.storage] : []
                content {
                  dynamic "service_configuration" {
                    for_each = storage.value.service_configuration != null ? [storage.value.service_configuration] : []
                    content {
                      dynamic "s3" {
                        for_each = service_configuration.value.s3 != null ? [service_configuration.value.s3] : []
                        content {
                          bucket_name = s3.value.bucket_name
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