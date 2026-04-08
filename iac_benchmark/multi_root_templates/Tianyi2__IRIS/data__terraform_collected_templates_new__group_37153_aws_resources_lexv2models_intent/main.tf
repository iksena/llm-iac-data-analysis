resource "aws_lexv2models_intent" "this" {
  bot_id      = var.bot_id
  bot_version = var.bot_version
  locale_id   = var.locale_id
  name        = var.name

  region                  = var.region
  description             = var.description
  parent_intent_signature = var.parent_intent_signature

  dynamic "closing_setting" {
    for_each = var.closing_setting != null ? [var.closing_setting] : []
    content {
      active = closing_setting.value.active

      dynamic "closing_response" {
        for_each = closing_setting.value.closing_response != null ? [closing_setting.value.closing_response] : []
        content {
          allow_interrupt = closing_response.value.allow_interrupt

          dynamic "message_group" {
            for_each = closing_response.value.message_group
            content {
              dynamic "message" {
                for_each = [message_group.value.message]
                content {
                  dynamic "custom_payload" {
                    for_each = message.value.custom_payload != null ? [message.value.custom_payload] : []
                    content {
                      value = custom_payload.value.value
                    }
                  }

                  dynamic "image_response_card" {
                    for_each = message.value.image_response_card != null ? [message.value.image_response_card] : []
                    content {
                      title     = image_response_card.value.title
                      image_url = image_response_card.value.image_url
                      subtitle  = image_response_card.value.subtitle

                      dynamic "button" {
                        for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                        content {
                          text  = button.value.text
                          value = button.value.value
                        }
                      }
                    }
                  }

                  dynamic "plain_text_message" {
                    for_each = message.value.plain_text_message != null ? [message.value.plain_text_message] : []
                    content {
                      value = plain_text_message.value.value
                    }
                  }

                  dynamic "ssml_message" {
                    for_each = message.value.ssml_message != null ? [message.value.ssml_message] : []
                    content {
                      value = ssml_message.value.value
                    }
                  }
                }
              }

              dynamic "variation" {
                for_each = message_group.value.variation != null ? message_group.value.variation : []
                content {
                  dynamic "custom_payload" {
                    for_each = variation.value.custom_payload != null ? [variation.value.custom_payload] : []
                    content {
                      value = custom_payload.value.value
                    }
                  }

                  dynamic "image_response_card" {
                    for_each = variation.value.image_response_card != null ? [variation.value.image_response_card] : []
                    content {
                      title     = image_response_card.value.title
                      image_url = image_response_card.value.image_url
                      subtitle  = image_response_card.value.subtitle

                      dynamic "button" {
                        for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                        content {
                          text  = button.value.text
                          value = button.value.value
                        }
                      }
                    }
                  }

                  dynamic "plain_text_message" {
                    for_each = variation.value.plain_text_message != null ? [variation.value.plain_text_message] : []
                    content {
                      value = plain_text_message.value.value
                    }
                  }

                  dynamic "ssml_message" {
                    for_each = variation.value.ssml_message != null ? [variation.value.ssml_message] : []
                    content {
                      value = ssml_message.value.value
                    }
                  }
                }
              }
            }
          }
        }
      }

      dynamic "conditional" {
        for_each = closing_setting.value.conditional != null ? [closing_setting.value.conditional] : []
        content {
          active = conditional.value.active

          dynamic "conditional_branch" {
            for_each = conditional.value.conditional_branch
            content {
              name = conditional_branch.value.name

              dynamic "condition" {
                for_each = [conditional_branch.value.condition]
                content {
                  expression_string = condition.value.expression_string
                }
              }

              dynamic "next_step" {
                for_each = [conditional_branch.value.next_step]
                content {
                  session_attributes = next_step.value.session_attributes

                  dynamic "dialog_action" {
                    for_each = next_step.value.dialog_action != null ? [next_step.value.dialog_action] : []
                    content {
                      type                  = dialog_action.value.type
                      slot_to_elicit        = dialog_action.value.slot_to_elicit
                      suppress_next_message = dialog_action.value.suppress_next_message
                    }
                  }

                  dynamic "intent" {
                    for_each = next_step.value.intent != null ? [next_step.value.intent] : []
                    content {
                      name = intent.value.name

                      dynamic "slot" {
                        for_each = intent.value.slot != null ? intent.value.slot : {}
                        content {
                          map_block_key = slot.key
                          shape         = slot.value.shape

                          dynamic "value" {
                            for_each = slot.value.value != null ? [slot.value.value] : []
                            content {
                              interpreted_value = value.value.interpreted_value
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }

              dynamic "response" {
                for_each = conditional_branch.value.response != null ? [conditional_branch.value.response] : []
                content {
                  allow_interrupt = response.value.allow_interrupt

                  dynamic "message_group" {
                    for_each = response.value.message_group
                    content {
                      dynamic "message" {
                        for_each = [message_group.value.message]
                        content {
                          dynamic "custom_payload" {
                            for_each = message.value.custom_payload != null ? [message.value.custom_payload] : []
                            content {
                              value = custom_payload.value.value
                            }
                          }

                          dynamic "image_response_card" {
                            for_each = message.value.image_response_card != null ? [message.value.image_response_card] : []
                            content {
                              title     = image_response_card.value.title
                              image_url = image_response_card.value.image_url
                              subtitle  = image_response_card.value.subtitle

                              dynamic "button" {
                                for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                                content {
                                  text  = button.value.text
                                  value = button.value.value
                                }
                              }
                            }
                          }

                          dynamic "plain_text_message" {
                            for_each = message.value.plain_text_message != null ? [message.value.plain_text_message] : []
                            content {
                              value = plain_text_message.value.value
                            }
                          }

                          dynamic "ssml_message" {
                            for_each = message.value.ssml_message != null ? [message.value.ssml_message] : []
                            content {
                              value = ssml_message.value.value
                            }
                          }
                        }
                      }

                      dynamic "variation" {
                        for_each = message_group.value.variation != null ? message_group.value.variation : []
                        content {
                          dynamic "custom_payload" {
                            for_each = variation.value.custom_payload != null ? [variation.value.custom_payload] : []
                            content {
                              value = custom_payload.value.value
                            }
                          }

                          dynamic "image_response_card" {
                            for_each = variation.value.image_response_card != null ? [variation.value.image_response_card] : []
                            content {
                              title     = image_response_card.value.title
                              image_url = image_response_card.value.image_url
                              subtitle  = image_response_card.value.subtitle

                              dynamic "button" {
                                for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                                content {
                                  text  = button.value.text
                                  value = button.value.value
                                }
                              }
                            }
                          }

                          dynamic "plain_text_message" {
                            for_each = variation.value.plain_text_message != null ? [variation.value.plain_text_message] : []
                            content {
                              value = plain_text_message.value.value
                            }
                          }

                          dynamic "ssml_message" {
                            for_each = variation.value.ssml_message != null ? [variation.value.ssml_message] : []
                            content {
                              value = ssml_message.value.value
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

          dynamic "default_branch" {
            for_each = [conditional.value.default_branch]
            content {
              dynamic "next_step" {
                for_each = [default_branch.value.next_step]
                content {
                  session_attributes = next_step.value.session_attributes

                  dynamic "dialog_action" {
                    for_each = next_step.value.dialog_action != null ? [next_step.value.dialog_action] : []
                    content {
                      type                  = dialog_action.value.type
                      slot_to_elicit        = dialog_action.value.slot_to_elicit
                      suppress_next_message = dialog_action.value.suppress_next_message
                    }
                  }

                  dynamic "intent" {
                    for_each = next_step.value.intent != null ? [next_step.value.intent] : []
                    content {
                      name = intent.value.name

                      dynamic "slot" {
                        for_each = intent.value.slot != null ? intent.value.slot : {}
                        content {
                          map_block_key = slot.key
                          shape         = slot.value.shape

                          dynamic "value" {
                            for_each = slot.value.value != null ? [slot.value.value] : []
                            content {
                              interpreted_value = value.value.interpreted_value
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }

              dynamic "response" {
                for_each = default_branch.value.response != null ? [default_branch.value.response] : []
                content {
                  allow_interrupt = response.value.allow_interrupt

                  dynamic "message_group" {
                    for_each = response.value.message_group
                    content {
                      dynamic "message" {
                        for_each = [message_group.value.message]
                        content {
                          dynamic "custom_payload" {
                            for_each = message.value.custom_payload != null ? [message.value.custom_payload] : []
                            content {
                              value = custom_payload.value.value
                            }
                          }

                          dynamic "image_response_card" {
                            for_each = message.value.image_response_card != null ? [message.value.image_response_card] : []
                            content {
                              title     = image_response_card.value.title
                              image_url = image_response_card.value.image_url
                              subtitle  = image_response_card.value.subtitle

                              dynamic "button" {
                                for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                                content {
                                  text  = button.value.text
                                  value = button.value.value
                                }
                              }
                            }
                          }

                          dynamic "plain_text_message" {
                            for_each = message.value.plain_text_message != null ? [message.value.plain_text_message] : []
                            content {
                              value = plain_text_message.value.value
                            }
                          }

                          dynamic "ssml_message" {
                            for_each = message.value.ssml_message != null ? [message.value.ssml_message] : []
                            content {
                              value = ssml_message.value.value
                            }
                          }
                        }
                      }

                      dynamic "variation" {
                        for_each = message_group.value.variation != null ? message_group.value.variation : []
                        content {
                          dynamic "custom_payload" {
                            for_each = variation.value.custom_payload != null ? [variation.value.custom_payload] : []
                            content {
                              value = custom_payload.value.value
                            }
                          }

                          dynamic "image_response_card" {
                            for_each = variation.value.image_response_card != null ? [variation.value.image_response_card] : []
                            content {
                              title     = image_response_card.value.title
                              image_url = image_response_card.value.image_url
                              subtitle  = image_response_card.value.subtitle

                              dynamic "button" {
                                for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                                content {
                                  text  = button.value.text
                                  value = button.value.value
                                }
                              }
                            }
                          }

                          dynamic "plain_text_message" {
                            for_each = variation.value.plain_text_message != null ? [variation.value.plain_text_message] : []
                            content {
                              value = plain_text_message.value.value
                            }
                          }

                          dynamic "ssml_message" {
                            for_each = variation.value.ssml_message != null ? [variation.value.ssml_message] : []
                            content {
                              value = ssml_message.value.value
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

      dynamic "next_step" {
        for_each = closing_setting.value.next_step != null ? [closing_setting.value.next_step] : []
        content {
          session_attributes = next_step.value.session_attributes

          dynamic "dialog_action" {
            for_each = next_step.value.dialog_action != null ? [next_step.value.dialog_action] : []
            content {
              type                  = dialog_action.value.type
              slot_to_elicit        = dialog_action.value.slot_to_elicit
              suppress_next_message = dialog_action.value.suppress_next_message
            }
          }

          dynamic "intent" {
            for_each = next_step.value.intent != null ? [next_step.value.intent] : []
            content {
              name = intent.value.name

              dynamic "slot" {
                for_each = intent.value.slot != null ? intent.value.slot : {}
                content {
                  map_block_key = slot.key
                  shape         = slot.value.shape

                  dynamic "value" {
                    for_each = slot.value.value != null ? [slot.value.value] : []
                    content {
                      interpreted_value = value.value.interpreted_value
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

  dynamic "confirmation_setting" {
    for_each = var.confirmation_setting != null ? [var.confirmation_setting] : []
    content {
      active = confirmation_setting.value.active

      dynamic "prompt_specification" {
        for_each = [confirmation_setting.value.prompt_specification]
        content {
          max_retries                = prompt_specification.value.max_retries
          allow_interrupt            = prompt_specification.value.allow_interrupt
          message_selection_strategy = prompt_specification.value.message_selection_strategy

          dynamic "message_group" {
            for_each = prompt_specification.value.message_group
            content {
              dynamic "message" {
                for_each = [message_group.value.message]
                content {
                  dynamic "custom_payload" {
                    for_each = message.value.custom_payload != null ? [message.value.custom_payload] : []
                    content {
                      value = custom_payload.value.value
                    }
                  }

                  dynamic "image_response_card" {
                    for_each = message.value.image_response_card != null ? [message.value.image_response_card] : []
                    content {
                      title     = image_response_card.value.title
                      image_url = image_response_card.value.image_url
                      subtitle  = image_response_card.value.subtitle

                      dynamic "button" {
                        for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                        content {
                          text  = button.value.text
                          value = button.value.value
                        }
                      }
                    }
                  }

                  dynamic "plain_text_message" {
                    for_each = message.value.plain_text_message != null ? [message.value.plain_text_message] : []
                    content {
                      value = plain_text_message.value.value
                    }
                  }

                  dynamic "ssml_message" {
                    for_each = message.value.ssml_message != null ? [message.value.ssml_message] : []
                    content {
                      value = ssml_message.value.value
                    }
                  }
                }
              }

              dynamic "variation" {
                for_each = message_group.value.variation != null ? message_group.value.variation : []
                content {
                  dynamic "custom_payload" {
                    for_each = variation.value.custom_payload != null ? [variation.value.custom_payload] : []
                    content {
                      value = custom_payload.value.value
                    }
                  }

                  dynamic "image_response_card" {
                    for_each = variation.value.image_response_card != null ? [variation.value.image_response_card] : []
                    content {
                      title     = image_response_card.value.title
                      image_url = image_response_card.value.image_url
                      subtitle  = image_response_card.value.subtitle

                      dynamic "button" {
                        for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                        content {
                          text  = button.value.text
                          value = button.value.value
                        }
                      }
                    }
                  }

                  dynamic "plain_text_message" {
                    for_each = variation.value.plain_text_message != null ? [variation.value.plain_text_message] : []
                    content {
                      value = plain_text_message.value.value
                    }
                  }

                  dynamic "ssml_message" {
                    for_each = variation.value.ssml_message != null ? [variation.value.ssml_message] : []
                    content {
                      value = ssml_message.value.value
                    }
                  }
                }
              }
            }
          }

          dynamic "prompt_attempts_specification" {
            for_each = prompt_specification.value.prompt_attempts_specification != null ? prompt_specification.value.prompt_attempts_specification : []
            content {
              map_block_key   = prompt_attempts_specification.value.map_block_key
              allow_interrupt = prompt_attempts_specification.value.allow_interrupt

              dynamic "allowed_input_types" {
                for_each = [prompt_attempts_specification.value.allowed_input_types]
                content {
                  allow_audio_input = allowed_input_types.value.allow_audio_input
                  allow_dtmf_input  = allowed_input_types.value.allow_dtmf_input
                }
              }

              dynamic "audio_and_dtmf_input_specification" {
                for_each = prompt_attempts_specification.value.audio_and_dtmf_input_specification != null ? [prompt_attempts_specification.value.audio_and_dtmf_input_specification] : []
                content {
                  start_timeout_ms = audio_and_dtmf_input_specification.value.start_timeout_ms

                  dynamic "audio_specification" {
                    for_each = audio_and_dtmf_input_specification.value.audio_specification != null ? [audio_and_dtmf_input_specification.value.audio_specification] : []
                    content {
                      end_timeout_ms = audio_specification.value.end_timeout_ms
                      max_length_ms  = audio_specification.value.max_length_ms
                    }
                  }

                  dynamic "dtmf_specification" {
                    for_each = audio_and_dtmf_input_specification.value.dtmf_specification != null ? [audio_and_dtmf_input_specification.value.dtmf_specification] : []
                    content {
                      deletion_character = dtmf_specification.value.deletion_character
                      end_character      = dtmf_specification.value.end_character
                      end_timeout_ms     = dtmf_specification.value.end_timeout_ms
                      max_length         = dtmf_specification.value.max_length
                    }
                  }
                }
              }

              dynamic "text_input_specification" {
                for_each = prompt_attempts_specification.value.text_input_specification != null ? [prompt_attempts_specification.value.text_input_specification] : []
                content {
                  start_timeout_ms = text_input_specification.value.start_timeout_ms
                }
              }
            }
          }
        }
      }

      dynamic "code_hook" {
        for_each = confirmation_setting.value.code_hook != null ? [confirmation_setting.value.code_hook] : []
        content {
          active                      = code_hook.value.active
          enable_code_hook_invocation = code_hook.value.enable_code_hook_invocation
          invocation_label            = code_hook.value.invocation_label

          dynamic "post_code_hook_specification" {
            for_each = [code_hook.value.post_code_hook_specification]
            content {
              dynamic "failure_conditional" {
                for_each = post_code_hook_specification.value.failure_conditional != null ? [post_code_hook_specification.value.failure_conditional] : []
                content {
                  active = failure_conditional.value.active

                  dynamic "conditional_branch" {
                    for_each = failure_conditional.value.conditional_branch
                    content {
                      name = conditional_branch.value.name

                      dynamic "condition" {
                        for_each = [conditional_branch.value.condition]
                        content {
                          expression_string = condition.value.expression_string
                        }
                      }

                      dynamic "next_step" {
                        for_each = [conditional_branch.value.next_step]
                        content {
                          session_attributes = next_step.value.session_attributes

                          dynamic "dialog_action" {
                            for_each = next_step.value.dialog_action != null ? [next_step.value.dialog_action] : []
                            content {
                              type                  = dialog_action.value.type
                              slot_to_elicit        = dialog_action.value.slot_to_elicit
                              suppress_next_message = dialog_action.value.suppress_next_message
                            }
                          }

                          dynamic "intent" {
                            for_each = next_step.value.intent != null ? [next_step.value.intent] : []
                            content {
                              name = intent.value.name

                              dynamic "slot" {
                                for_each = intent.value.slot != null ? intent.value.slot : {}
                                content {
                                  map_block_key = slot.key
                                  shape         = slot.value.shape

                                  dynamic "value" {
                                    for_each = slot.value.value != null ? [slot.value.value] : []
                                    content {
                                      interpreted_value = value.value.interpreted_value
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }

                      dynamic "response" {
                        for_each = conditional_branch.value.response != null ? [conditional_branch.value.response] : []
                        content {
                          allow_interrupt = response.value.allow_interrupt

                          dynamic "message_group" {
                            for_each = response.value.message_group
                            content {
                              dynamic "message" {
                                for_each = [message_group.value.message]
                                content {
                                  dynamic "custom_payload" {
                                    for_each = message.value.custom_payload != null ? [message.value.custom_payload] : []
                                    content {
                                      value = custom_payload.value.value
                                    }
                                  }

                                  dynamic "image_response_card" {
                                    for_each = message.value.image_response_card != null ? [message.value.image_response_card] : []
                                    content {
                                      title     = image_response_card.value.title
                                      image_url = image_response_card.value.image_url
                                      subtitle  = image_response_card.value.subtitle

                                      dynamic "button" {
                                        for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                                        content {
                                          text  = button.value.text
                                          value = button.value.value
                                        }
                                      }
                                    }
                                  }

                                  dynamic "plain_text_message" {
                                    for_each = message.value.plain_text_message != null ? [message.value.plain_text_message] : []
                                    content {
                                      value = plain_text_message.value.value
                                    }
                                  }

                                  dynamic "ssml_message" {
                                    for_each = message.value.ssml_message != null ? [message.value.ssml_message] : []
                                    content {
                                      value = ssml_message.value.value
                                    }
                                  }
                                }
                              }

                              dynamic "variation" {
                                for_each = message_group.value.variation != null ? message_group.value.variation : []
                                content {
                                  dynamic "custom_payload" {
                                    for_each = variation.value.custom_payload != null ? [variation.value.custom_payload] : []
                                    content {
                                      value = custom_payload.value.value
                                    }
                                  }

                                  dynamic "image_response_card" {
                                    for_each = variation.value.image_response_card != null ? [variation.value.image_response_card] : []
                                    content {
                                      title     = image_response_card.value.title
                                      image_url = image_response_card.value.image_url
                                      subtitle  = image_response_card.value.subtitle

                                      dynamic "button" {
                                        for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                                        content {
                                          text  = button.value.text
                                          value = button.value.value
                                        }
                                      }
                                    }
                                  }

                                  dynamic "plain_text_message" {
                                    for_each = variation.value.plain_text_message != null ? [variation.value.plain_text_message] : []
                                    content {
                                      value = plain_text_message.value.value
                                    }
                                  }

                                  dynamic "ssml_message" {
                                    for_each = variation.value.ssml_message != null ? [variation.value.ssml_message] : []
                                    content {
                                      value = ssml_message.value.value
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

                  dynamic "default_branch" {
                    for_each = [failure_conditional.value.default_branch]
                    content {
                      dynamic "next_step" {
                        for_each = [default_branch.value.next_step]
                        content {
                          session_attributes = next_step.value.session_attributes

                          dynamic "dialog_action" {
                            for_each = next_step.value.dialog_action != null ? [next_step.value.dialog_action] : []
                            content {
                              type                  = dialog_action.value.type
                              slot_to_elicit        = dialog_action.value.slot_to_elicit
                              suppress_next_message = dialog_action.value.suppress_next_message
                            }
                          }

                          dynamic "intent" {
                            for_each = next_step.value.intent != null ? [next_step.value.intent] : []
                            content {
                              name = intent.value.name

                              dynamic "slot" {
                                for_each = intent.value.slot != null ? intent.value.slot : {}
                                content {
                                  map_block_key = slot.key
                                  shape         = slot.value.shape

                                  dynamic "value" {
                                    for_each = slot.value.value != null ? [slot.value.value] : []
                                    content {
                                      interpreted_value = value.value.interpreted_value
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }

                      dynamic "response" {
                        for_each = default_branch.value.response != null ? [default_branch.value.response] : []
                        content {
                          allow_interrupt = response.value.allow_interrupt

                          dynamic "message_group" {
                            for_each = response.value.message_group
                            content {
                              dynamic "message" {
                                for_each = [message_group.value.message]
                                content {
                                  dynamic "custom_payload" {
                                    for_each = message.value.custom_payload != null ? [message.value.custom_payload] : []
                                    content {
                                      value = custom_payload.value.value
                                    }
                                  }

                                  dynamic "image_response_card" {
                                    for_each = message.value.image_response_card != null ? [message.value.image_response_card] : []
                                    content {
                                      title     = image_response_card.value.title
                                      image_url = image_response_card.value.image_url
                                      subtitle  = image_response_card.value.subtitle

                                      dynamic "button" {
                                        for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                                        content {
                                          text  = button.value.text
                                          value = button.value.value
                                        }
                                      }
                                    }
                                  }

                                  dynamic "plain_text_message" {
                                    for_each = message.value.plain_text_message != null ? [message.value.plain_text_message] : []
                                    content {
                                      value = plain_text_message.value.value
                                    }
                                  }

                                  dynamic "ssml_message" {
                                    for_each = message.value.ssml_message != null ? [message.value.ssml_message] : []
                                    content {
                                      value = ssml_message.value.value
                                    }
                                  }
                                }
                              }

                              dynamic "variation" {
                                for_each = message_group.value.variation != null ? message_group.value.variation : []
                                content {
                                  dynamic "custom_payload" {
                                    for_each = variation.value.custom_payload != null ? [variation.value.custom_payload] : []
                                    content {
                                      value = custom_payload.value.value
                                    }
                                  }

                                  dynamic "image_response_card" {
                                    for_each = variation.value.image_response_card != null ? [variation.value.image_response_card] : []
                                    content {
                                      title     = image_response_card.value.title
                                      image_url = image_response_card.value.image_url
                                      subtitle  = image_response_card.value.subtitle

                                      dynamic "button" {
                                        for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                                        content {
                                          text  = button.value.text
                                          value = button.value.value
                                        }
                                      }
                                    }
                                  }

                                  dynamic "plain_text_message" {
                                    for_each = variation.value.plain_text_message != null ? [variation.value.plain_text_message] : []
                                    content {
                                      value = plain_text_message.value.value
                                    }
                                  }

                                  dynamic "ssml_message" {
                                    for_each = variation.value.ssml_message != null ? [variation.value.ssml_message] : []
                                    content {
                                      value = ssml_message.value.value
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

              dynamic "failure_next_step" {
                for_each = post_code_hook_specification.value.failure_next_step != null ? [post_code_hook_specification.value.failure_next_step] : []
                content {
                  session_attributes = failure_next_step.value.session_attributes

                  dynamic "dialog_action" {
                    for_each = failure_next_step.value.dialog_action != null ? [failure_next_step.value.dialog_action] : []
                    content {
                      type                  = dialog_action.value.type
                      slot_to_elicit        = dialog_action.value.slot_to_elicit
                      suppress_next_message = dialog_action.value.suppress_next_message
                    }
                  }

                  dynamic "intent" {
                    for_each = failure_next_step.value.intent != null ? [failure_next_step.value.intent] : []
                    content {
                      name = intent.value.name

                      dynamic "slot" {
                        for_each = intent.value.slot != null ? intent.value.slot : {}
                        content {
                          map_block_key = slot.key
                          shape         = slot.value.shape

                          dynamic "value" {
                            for_each = slot.value.value != null ? [slot.value.value] : []
                            content {
                              interpreted_value = value.value.interpreted_value
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }

              dynamic "failure_response" {
                for_each = post_code_hook_specification.value.failure_response != null ? [post_code_hook_specification.value.failure_response] : []
                content {
                  allow_interrupt = failure_response.value.allow_interrupt

                  dynamic "message_group" {
                    for_each = failure_response.value.message_group
                    content {
                      dynamic "message" {
                        for_each = [message_group.value.message]
                        content {
                          dynamic "custom_payload" {
                            for_each = message.value.custom_payload != null ? [message.value.custom_payload] : []
                            content {
                              value = custom_payload.value.value
                            }
                          }

                          dynamic "image_response_card" {
                            for_each = message.value.image_response_card != null ? [message.value.image_response_card] : []
                            content {
                              title     = image_response_card.value.title
                              image_url = image_response_card.value.image_url
                              subtitle  = image_response_card.value.subtitle

                              dynamic "button" {
                                for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                                content {
                                  text  = button.value.text
                                  value = button.value.value
                                }
                              }
                            }
                          }

                          dynamic "plain_text_message" {
                            for_each = message.value.plain_text_message != null ? [message.value.plain_text_message] : []
                            content {
                              value = plain_text_message.value.value
                            }
                          }

                          dynamic "ssml_message" {
                            for_each = message.value.ssml_message != null ? [message.value.ssml_message] : []
                            content {
                              value = ssml_message.value.value
                            }
                          }
                        }
                      }

                      dynamic "variation" {
                        for_each = message_group.value.variation != null ? message_group.value.variation : []
                        content {
                          dynamic "custom_payload" {
                            for_each = variation.value.custom_payload != null ? [variation.value.custom_payload] : []
                            content {
                              value = custom_payload.value.value
                            }
                          }

                          dynamic "image_response_card" {
                            for_each = variation.value.image_response_card != null ? [variation.value.image_response_card] : []
                            content {
                              title     = image_response_card.value.title
                              image_url = image_response_card.value.image_url
                              subtitle  = image_response_card.value.subtitle

                              dynamic "button" {
                                for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                                content {
                                  text  = button.value.text
                                  value = button.value.value
                                }
                              }
                            }
                          }

                          dynamic "plain_text_message" {
                            for_each = variation.value.plain_text_message != null ? [variation.value.plain_text_message] : []
                            content {
                              value = plain_text_message.value.value
                            }
                          }

                          dynamic "ssml_message" {
                            for_each = variation.value.ssml_message != null ? [variation.value.ssml_message] : []
                            content {
                              value = ssml_message.value.value
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }

              dynamic "success_conditional" {
                for_each = post_code_hook_specification.value.success_conditional != null ? [post_code_hook_specification.value.success_conditional] : []
                content {
                  active = success_conditional.value.active

                  dynamic "conditional_branch" {
                    for_each = success_conditional.value.conditional_branch
                    content {
                      name = conditional_branch.value.name

                      dynamic "condition" {
                        for_each = [conditional_branch.value.condition]
                        content {
                          expression_string = condition.value.expression_string
                        }
                      }

                      dynamic "next_step" {
                        for_each = [conditional_branch.value.next_step]
                        content {
                          session_attributes = next_step.value.session_attributes

                          dynamic "dialog_action" {
                            for_each = next_step.value.dialog_action != null ? [next_step.value.dialog_action] : []
                            content {
                              type                  = dialog_action.value.type
                              slot_to_elicit        = dialog_action.value.slot_to_elicit
                              suppress_next_message = dialog_action.value.suppress_next_message
                            }
                          }

                          dynamic "intent" {
                            for_each = next_step.value.intent != null ? [next_step.value.intent] : []
                            content {
                              name = intent.value.name

                              dynamic "slot" {
                                for_each = intent.value.slot != null ? intent.value.slot : {}
                                content {
                                  map_block_key = slot.key
                                  shape         = slot.value.shape

                                  dynamic "value" {
                                    for_each = slot.value.value != null ? [slot.value.value] : []
                                    content {
                                      interpreted_value = value.value.interpreted_value
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }

                      dynamic "response" {
                        for_each = conditional_branch.value.response != null ? [conditional_branch.value.response] : []
                        content {
                          allow_interrupt = response.value.allow_interrupt

                          dynamic "message_group" {
                            for_each = response.value.message_group
                            content {
                              dynamic "message" {
                                for_each = [message_group.value.message]
                                content {
                                  dynamic "custom_payload" {
                                    for_each = message.value.custom_payload != null ? [message.value.custom_payload] : []
                                    content {
                                      value = custom_payload.value.value
                                    }
                                  }

                                  dynamic "image_response_card" {
                                    for_each = message.value.image_response_card != null ? [message.value.image_response_card] : []
                                    content {
                                      title     = image_response_card.value.title
                                      image_url = image_response_card.value.image_url
                                      subtitle  = image_response_card.value.subtitle

                                      dynamic "button" {
                                        for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                                        content {
                                          text  = button.value.text
                                          value = button.value.value
                                        }
                                      }
                                    }
                                  }

                                  dynamic "plain_text_message" {
                                    for_each = message.value.plain_text_message != null ? [message.value.plain_text_message] : []
                                    content {
                                      value = plain_text_message.value.value
                                    }
                                  }

                                  dynamic "ssml_message" {
                                    for_each = message.value.ssml_message != null ? [message.value.ssml_message] : []
                                    content {
                                      value = ssml_message.value.value
                                    }
                                  }
                                }
                              }

                              dynamic "variation" {
                                for_each = message_group.value.variation != null ? message_group.value.variation : []
                                content {
                                  dynamic "custom_payload" {
                                    for_each = variation.value.custom_payload != null ? [variation.value.custom_payload] : []
                                    content {
                                      value = custom_payload.value.value
                                    }
                                  }

                                  dynamic "image_response_card" {
                                    for_each = variation.value.image_response_card != null ? [variation.value.image_response_card] : []
                                    content {
                                      title     = image_response_card.value.title
                                      image_url = image_response_card.value.image_url
                                      subtitle  = image_response_card.value.subtitle

                                      dynamic "button" {
                                        for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                                        content {
                                          text  = button.value.text
                                          value = button.value.value
                                        }
                                      }
                                    }
                                  }

                                  dynamic "plain_text_message" {
                                    for_each = variation.value.plain_text_message != null ? [variation.value.plain_text_message] : []
                                    content {
                                      value = plain_text_message.value.value
                                    }
                                  }

                                  dynamic "ssml_message" {
                                    for_each = variation.value.ssml_message != null ? [variation.value.ssml_message] : []
                                    content {
                                      value = ssml_message.value.value
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

                  dynamic "default_branch" {
                    for_each = [success_conditional.value.default_branch]
                    content {
                      dynamic "next_step" {
                        for_each = [default_branch.value.next_step]
                        content {
                          session_attributes = next_step.value.session_attributes

                          dynamic "dialog_action" {
                            for_each = next_step.value.dialog_action != null ? [next_step.value.dialog_action] : []
                            content {
                              type                  = dialog_action.value.type
                              slot_to_elicit        = dialog_action.value.slot_to_elicit
                              suppress_next_message = dialog_action.value.suppress_next_message
                            }
                          }

                          dynamic "intent" {
                            for_each = next_step.value.intent != null ? [next_step.value.intent] : []
                            content {
                              name = intent.value.name

                              dynamic "slot" {
                                for_each = intent.value.slot != null ? intent.value.slot : {}
                                content {
                                  map_block_key = slot.key
                                  shape         = slot.value.shape

                                  dynamic "value" {
                                    for_each = slot.value.value != null ? [slot.value.value] : []
                                    content {
                                      interpreted_value = value.value.interpreted_value
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }

                      dynamic "response" {
                        for_each = default_branch.value.response != null ? [default_branch.value.response] : []
                        content {
                          allow_interrupt = response.value.allow_interrupt

                          dynamic "message_group" {
                            for_each = response.value.message_group
                            content {
                              dynamic "message" {
                                for_each = [message_group.value.message]
                                content {
                                  dynamic "custom_payload" {
                                    for_each = message.value.custom_payload != null ? [message.value.custom_payload] : []
                                    content {
                                      value = custom_payload.value.value
                                    }
                                  }

                                  dynamic "image_response_card" {
                                    for_each = message.value.image_response_card != null ? [message.value.image_response_card] : []
                                    content {
                                      title     = image_response_card.value.title
                                      image_url = image_response_card.value.image_url
                                      subtitle  = image_response_card.value.subtitle

                                      dynamic "button" {
                                        for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                                        content {
                                          text  = button.value.text
                                          value = button.value.value
                                        }
                                      }
                                    }
                                  }

                                  dynamic "plain_text_message" {
                                    for_each = message.value.plain_text_message != null ? [message.value.plain_text_message] : []
                                    content {
                                      value = plain_text_message.value.value
                                    }
                                  }

                                  dynamic "ssml_message" {
                                    for_each = message.value.ssml_message != null ? [message.value.ssml_message] : []
                                    content {
                                      value = ssml_message.value.value
                                    }
                                  }
                                }
                              }

                              dynamic "variation" {
                                for_each = message_group.value.variation != null ? message_group.value.variation : []
                                content {
                                  dynamic "custom_payload" {
                                    for_each = variation.value.custom_payload != null ? [variation.value.custom_payload] : []
                                    content {
                                      value = custom_payload.value.value
                                    }
                                  }

                                  dynamic "image_response_card" {
                                    for_each = variation.value.image_response_card != null ? [variation.value.image_response_card] : []
                                    content {
                                      title     = image_response_card.value.title
                                      image_url = image_response_card.value.image_url
                                      subtitle  = image_response_card.value.subtitle

                                      dynamic "button" {
                                        for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                                        content {
                                          text  = button.value.text
                                          value = button.value.value
                                        }
                                      }
                                    }
                                  }

                                  dynamic "plain_text_message" {
                                    for_each = variation.value.plain_text_message != null ? [variation.value.plain_text_message] : []
                                    content {
                                      value = plain_text_message.value.value
                                    }
                                  }

                                  dynamic "ssml_message" {
                                    for_each = variation.value.ssml_message != null ? [variation.value.ssml_message] : []
                                    content {
                                      value = ssml_message.value.value
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

              dynamic "success_next_step" {
                for_each = post_code_hook_specification.value.success_next_step != null ? [post_code_hook_specification.value.success_next_step] : []
                content {
                  session_attributes = success_next_step.value.session_attributes

                  dynamic "dialog_action" {
                    for_each = success_next_step.value.dialog_action != null ? [success_next_step.value.dialog_action] : []
                    content {
                      type                  = dialog_action.value.type
                      slot_to_elicit        = dialog_action.value.slot_to_elicit
                      suppress_next_message = dialog_action.value.suppress_next_message
                    }
                  }

                  dynamic "intent" {
                    for_each = success_next_step.value.intent != null ? [success_next_step.value.intent] : []
                    content {
                      name = intent.value.name

                      dynamic "slot" {
                        for_each = intent.value.slot != null ? intent.value.slot : {}
                        content {
                          map_block_key = slot.key
                          shape         = slot.value.shape

                          dynamic "value" {
                            for_each = slot.value.value != null ? [slot.value.value] : []
                            content {
                              interpreted_value = value.value.interpreted_value
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }

              dynamic "success_response" {
                for_each = post_code_hook_specification.value.success_response != null ? [post_code_hook_specification.value.success_response] : []
                content {
                  allow_interrupt = success_response.value.allow_interrupt

                  dynamic "message_group" {
                    for_each = success_response.value.message_group
                    content {
                      dynamic "message" {
                        for_each = [message_group.value.message]
                        content {
                          dynamic "custom_payload" {
                            for_each = message.value.custom_payload != null ? [message.value.custom_payload] : []
                            content {
                              value = custom_payload.value.value
                            }
                          }

                          dynamic "image_response_card" {
                            for_each = message.value.image_response_card != null ? [message.value.image_response_card] : []
                            content {
                              title     = image_response_card.value.title
                              image_url = image_response_card.value.image_url
                              subtitle  = image_response_card.value.subtitle

                              dynamic "button" {
                                for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                                content {
                                  text  = button.value.text
                                  value = button.value.value
                                }
                              }
                            }
                          }

                          dynamic "plain_text_message" {
                            for_each = message.value.plain_text_message != null ? [message.value.plain_text_message] : []
                            content {
                              value = plain_text_message.value.value
                            }
                          }

                          dynamic "ssml_message" {
                            for_each = message.value.ssml_message != null ? [message.value.ssml_message] : []
                            content {
                              value = ssml_message.value.value
                            }
                          }
                        }
                      }

                      dynamic "variation" {
                        for_each = message_group.value.variation != null ? message_group.value.variation : []
                        content {
                          dynamic "custom_payload" {
                            for_each = variation.value.custom_payload != null ? [variation.value.custom_payload] : []
                            content {
                              value = custom_payload.value.value
                            }
                          }

                          dynamic "image_response_card" {
                            for_each = variation.value.image_response_card != null ? [variation.value.image_response_card] : []
                            content {
                              title     = image_response_card.value.title
                              image_url = image_response_card.value.image_url
                              subtitle  = image_response_card.value.subtitle

                              dynamic "button" {
                                for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                                content {
                                  text  = button.value.text
                                  value = button.value.value
                                }
                              }
                            }
                          }

                          dynamic "plain_text_message" {
                            for_each = variation.value.plain_text_message != null ? [variation.value.plain_text_message] : []
                            content {
                              value = plain_text_message.value.value
                            }
                          }

                          dynamic "ssml_message" {
                            for_each = variation.value.ssml_message != null ? [variation.value.ssml_message] : []
                            content {
                              value = ssml_message.value.value
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }

              dynamic "timeout_conditional" {
                for_each = post_code_hook_specification.value.timeout_conditional != null ? [post_code_hook_specification.value.timeout_conditional] : []
                content {
                  active = timeout_conditional.value.active

                  dynamic "conditional_branch" {
                    for_each = timeout_conditional.value.conditional_branch
                    content {
                      name = conditional_branch.value.name

                      dynamic "condition" {
                        for_each = [conditional_branch.value.condition]
                        content {
                          expression_string = condition.value.expression_string
                        }
                      }

                      dynamic "next_step" {
                        for_each = [conditional_branch.value.next_step]
                        content {
                          session_attributes = next_step.value.session_attributes

                          dynamic "dialog_action" {
                            for_each = next_step.value.dialog_action != null ? [next_step.value.dialog_action] : []
                            content {
                              type                  = dialog_action.value.type
                              slot_to_elicit        = dialog_action.value.slot_to_elicit
                              suppress_next_message = dialog_action.value.suppress_next_message
                            }
                          }

                          dynamic "intent" {
                            for_each = next_step.value.intent != null ? [next_step.value.intent] : []
                            content {
                              name = intent.value.name

                              dynamic "slot" {
                                for_each = intent.value.slot != null ? intent.value.slot : {}
                                content {
                                  map_block_key = slot.key
                                  shape         = slot.value.shape

                                  dynamic "value" {
                                    for_each = slot.value.value != null ? [slot.value.value] : []
                                    content {
                                      interpreted_value = value.value.interpreted_value
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }

                      dynamic "response" {
                        for_each = conditional_branch.value.response != null ? [conditional_branch.value.response] : []
                        content {
                          allow_interrupt = response.value.allow_interrupt

                          dynamic "message_group" {
                            for_each = response.value.message_group
                            content {
                              dynamic "message" {
                                for_each = [message_group.value.message]
                                content {
                                  dynamic "custom_payload" {
                                    for_each = message.value.custom_payload != null ? [message.value.custom_payload] : []
                                    content {
                                      value = custom_payload.value.value
                                    }
                                  }

                                  dynamic "image_response_card" {
                                    for_each = message.value.image_response_card != null ? [message.value.image_response_card] : []
                                    content {
                                      title     = image_response_card.value.title
                                      image_url = image_response_card.value.image_url
                                      subtitle  = image_response_card.value.subtitle

                                      dynamic "button" {
                                        for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                                        content {
                                          text  = button.value.text
                                          value = button.value.value
                                        }
                                      }
                                    }
                                  }

                                  dynamic "plain_text_message" {
                                    for_each = message.value.plain_text_message != null ? [message.value.plain_text_message] : []
                                    content {
                                      value = plain_text_message.value.value
                                    }
                                  }

                                  dynamic "ssml_message" {
                                    for_each = message.value.ssml_message != null ? [message.value.ssml_message] : []
                                    content {
                                      value = ssml_message.value.value
                                    }
                                  }
                                }
                              }

                              dynamic "variation" {
                                for_each = message_group.value.variation != null ? message_group.value.variation : []
                                content {
                                  dynamic "custom_payload" {
                                    for_each = variation.value.custom_payload != null ? [variation.value.custom_payload] : []
                                    content {
                                      value = custom_payload.value.value
                                    }
                                  }

                                  dynamic "image_response_card" {
                                    for_each = variation.value.image_response_card != null ? [variation.value.image_response_card] : []
                                    content {
                                      title     = image_response_card.value.title
                                      image_url = image_response_card.value.image_url
                                      subtitle  = image_response_card.value.subtitle

                                      dynamic "button" {
                                        for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                                        content {
                                          text  = button.value.text
                                          value = button.value.value
                                        }
                                      }
                                    }
                                  }

                                  dynamic "plain_text_message" {
                                    for_each = variation.value.plain_text_message != null ? [variation.value.plain_text_message] : []
                                    content {
                                      value = plain_text_message.value.value
                                    }
                                  }

                                  dynamic "ssml_message" {
                                    for_each = variation.value.ssml_message != null ? [variation.value.ssml_message] : []
                                    content {
                                      value = ssml_message.value.value
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

                  dynamic "default_branch" {
                    for_each = [timeout_conditional.value.default_branch]
                    content {
                      dynamic "next_step" {
                        for_each = [default_branch.value.next_step]
                        content {
                          session_attributes = next_step.value.session_attributes

                          dynamic "dialog_action" {
                            for_each = next_step.value.dialog_action != null ? [next_step.value.dialog_action] : []
                            content {
                              type                  = dialog_action.value.type
                              slot_to_elicit        = dialog_action.value.slot_to_elicit
                              suppress_next_message = dialog_action.value.suppress_next_message
                            }
                          }

                          dynamic "intent" {
                            for_each = next_step.value.intent != null ? [next_step.value.intent] : []
                            content {
                              name = intent.value.name

                              dynamic "slot" {
                                for_each = intent.value.slot != null ? intent.value.slot : {}
                                content {
                                  map_block_key = slot.key
                                  shape         = slot.value.shape

                                  dynamic "value" {
                                    for_each = slot.value.value != null ? [slot.value.value] : []
                                    content {
                                      interpreted_value = value.value.interpreted_value
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }

                      dynamic "response" {
                        for_each = default_branch.value.response != null ? [default_branch.value.response] : []
                        content {
                          allow_interrupt = response.value.allow_interrupt

                          dynamic "message_group" {
                            for_each = response.value.message_group
                            content {
                              dynamic "message" {
                                for_each = [message_group.value.message]
                                content {
                                  dynamic "custom_payload" {
                                    for_each = message.value.custom_payload != null ? [message.value.custom_payload] : []
                                    content {
                                      value = custom_payload.value.value
                                    }
                                  }

                                  dynamic "image_response_card" {
                                    for_each = message.value.image_response_card != null ? [message.value.image_response_card] : []
                                    content {
                                      title     = image_response_card.value.title
                                      image_url = image_response_card.value.image_url
                                      subtitle  = image_response_card.value.subtitle

                                      dynamic "button" {
                                        for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                                        content {
                                          text  = button.value.text
                                          value = button.value.value
                                        }
                                      }
                                    }
                                  }

                                  dynamic "plain_text_message" {
                                    for_each = message.value.plain_text_message != null ? [message.value.plain_text_message] : []
                                    content {
                                      value = plain_text_message.value.value
                                    }
                                  }

                                  dynamic "ssml_message" {
                                    for_each = message.value.ssml_message != null ? [message.value.ssml_message] : []
                                    content {
                                      value = ssml_message.value.value
                                    }
                                  }
                                }
                              }

                              dynamic "variation" {
                                for_each = message_group.value.variation != null ? message_group.value.variation : []
                                content {
                                  dynamic "custom_payload" {
                                    for_each = variation.value.custom_payload != null ? [variation.value.custom_payload] : []
                                    content {
                                      value = custom_payload.value.value
                                    }
                                  }

                                  dynamic "image_response_card" {
                                    for_each = variation.value.image_response_card != null ? [variation.value.image_response_card] : []
                                    content {
                                      title     = image_response_card.value.title
                                      image_url = image_response_card.value.image_url
                                      subtitle  = image_response_card.value.subtitle

                                      dynamic "button" {
                                        for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                                        content {
                                          text  = button.value.text
                                          value = button.value.value
                                        }
                                      }
                                    }
                                  }

                                  dynamic "plain_text_message" {
                                    for_each = variation.value.plain_text_message != null ? [variation.value.plain_text_message] : []
                                    content {
                                      value = plain_text_message.value.value
                                    }
                                  }

                                  dynamic "ssml_message" {
                                    for_each = variation.value.ssml_message != null ? [variation.value.ssml_message] : []
                                    content {
                                      value = ssml_message.value.value
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

              dynamic "timeout_next_step" {
                for_each = post_code_hook_specification.value.timeout_next_step != null ? [post_code_hook_specification.value.timeout_next_step] : []
                content {
                  session_attributes = timeout_next_step.value.session_attributes

                  dynamic "dialog_action" {
                    for_each = timeout_next_step.value.dialog_action != null ? [timeout_next_step.value.dialog_action] : []
                    content {
                      type                  = dialog_action.value.type
                      slot_to_elicit        = dialog_action.value.slot_to_elicit
                      suppress_next_message = dialog_action.value.suppress_next_message
                    }
                  }

                  dynamic "intent" {
                    for_each = timeout_next_step.value.intent != null ? [timeout_next_step.value.intent] : []
                    content {
                      name = intent.value.name

                      dynamic "slot" {
                        for_each = intent.value.slot != null ? intent.value.slot : {}
                        content {
                          map_block_key = slot.key
                          shape         = slot.value.shape

                          dynamic "value" {
                            for_each = slot.value.value != null ? [slot.value.value] : []
                            content {
                              interpreted_value = value.value.interpreted_value
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }

              dynamic "timeout_response" {
                for_each = post_code_hook_specification.value.timeout_response != null ? [post_code_hook_specification.value.timeout_response] : []
                content {
                  allow_interrupt = timeout_response.value.allow_interrupt

                  dynamic "message_group" {
                    for_each = timeout_response.value.message_group
                    content {
                      dynamic "message" {
                        for_each = [message_group.value.message]
                        content {
                          dynamic "custom_payload" {
                            for_each = message.value.custom_payload != null ? [message.value.custom_payload] : []
                            content {
                              value = custom_payload.value.value
                            }
                          }

                          dynamic "image_response_card" {
                            for_each = message.value.image_response_card != null ? [message.value.image_response_card] : []
                            content {
                              title     = image_response_card.value.title
                              image_url = image_response_card.value.image_url
                              subtitle  = image_response_card.value.subtitle

                              dynamic "button" {
                                for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                                content {
                                  text  = button.value.text
                                  value = button.value.value
                                }
                              }
                            }
                          }

                          dynamic "plain_text_message" {
                            for_each = message.value.plain_text_message != null ? [message.value.plain_text_message] : []
                            content {
                              value = plain_text_message.value.value
                            }
                          }

                          dynamic "ssml_message" {
                            for_each = message.value.ssml_message != null ? [message.value.ssml_message] : []
                            content {
                              value = ssml_message.value.value
                            }
                          }
                        }
                      }

                      dynamic "variation" {
                        for_each = message_group.value.variation != null ? message_group.value.variation : []
                        content {
                          dynamic "custom_payload" {
                            for_each = variation.value.custom_payload != null ? [variation.value.custom_payload] : []
                            content {
                              value = custom_payload.value.value
                            }
                          }

                          dynamic "image_response_card" {
                            for_each = variation.value.image_response_card != null ? [variation.value.image_response_card] : []
                            content {
                              title     = image_response_card.value.title
                              image_url = image_response_card.value.image_url
                              subtitle  = image_response_card.value.subtitle

                              dynamic "button" {
                                for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                                content {
                                  text  = button.value.text
                                  value = button.value.value
                                }
                              }
                            }
                          }

                          dynamic "plain_text_message" {
                            for_each = variation.value.plain_text_message != null ? [variation.value.plain_text_message] : []
                            content {
                              value = plain_text_message.value.value
                            }
                          }

                          dynamic "ssml_message" {
                            for_each = variation.value.ssml_message != null ? [variation.value.ssml_message] : []
                            content {
                              value = ssml_message.value.value
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

      # Continue with other confirmation_setting blocks...
      # Due to length constraints, I need to continue this in another part
    }
  }

  dynamic "dialog_code_hook" {
    for_each = var.dialog_code_hook != null ? [var.dialog_code_hook] : []
    content {
      enabled = dialog_code_hook.value.enabled
    }
  }

  dynamic "fulfillment_code_hook" {
    for_each = var.fulfillment_code_hook != null ? [var.fulfillment_code_hook] : []
    content {
      enabled = fulfillment_code_hook.value.enabled
      active  = fulfillment_code_hook.value.active

      dynamic "fulfillment_updates_specification" {
        for_each = fulfillment_code_hook.value.fulfillment_updates_specification != null ? [fulfillment_code_hook.value.fulfillment_updates_specification] : []
        content {
          active             = fulfillment_updates_specification.value.active
          timeout_in_seconds = fulfillment_updates_specification.value.timeout_in_seconds

          dynamic "start_response" {
            for_each = fulfillment_updates_specification.value.start_response != null ? [fulfillment_updates_specification.value.start_response] : []
            content {
              delay_in_seconds = start_response.value.delay_in_seconds
              allow_interrupt  = start_response.value.allow_interrupt

              dynamic "message_group" {
                for_each = start_response.value.message_group
                content {
                  dynamic "message" {
                    for_each = [message_group.value.message]
                    content {
                      dynamic "custom_payload" {
                        for_each = message.value.custom_payload != null ? [message.value.custom_payload] : []
                        content {
                          value = custom_payload.value.value
                        }
                      }

                      dynamic "image_response_card" {
                        for_each = message.value.image_response_card != null ? [message.value.image_response_card] : []
                        content {
                          title     = image_response_card.value.title
                          image_url = image_response_card.value.image_url
                          subtitle  = image_response_card.value.subtitle

                          dynamic "button" {
                            for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                            content {
                              text  = button.value.text
                              value = button.value.value
                            }
                          }
                        }
                      }

                      dynamic "plain_text_message" {
                        for_each = message.value.plain_text_message != null ? [message.value.plain_text_message] : []
                        content {
                          value = plain_text_message.value.value
                        }
                      }

                      dynamic "ssml_message" {
                        for_each = message.value.ssml_message != null ? [message.value.ssml_message] : []
                        content {
                          value = ssml_message.value.value
                        }
                      }
                    }
                  }

                  dynamic "variation" {
                    for_each = message_group.value.variation != null ? message_group.value.variation : []
                    content {
                      dynamic "custom_payload" {
                        for_each = variation.value.custom_payload != null ? [variation.value.custom_payload] : []
                        content {
                          value = custom_payload.value.value
                        }
                      }

                      dynamic "image_response_card" {
                        for_each = variation.value.image_response_card != null ? [variation.value.image_response_card] : []
                        content {
                          title     = image_response_card.value.title
                          image_url = image_response_card.value.image_url
                          subtitle  = image_response_card.value.subtitle

                          dynamic "button" {
                            for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                            content {
                              text  = button.value.text
                              value = button.value.value
                            }
                          }
                        }
                      }

                      dynamic "plain_text_message" {
                        for_each = variation.value.plain_text_message != null ? [variation.value.plain_text_message] : []
                        content {
                          value = plain_text_message.value.value
                        }
                      }

                      dynamic "ssml_message" {
                        for_each = variation.value.ssml_message != null ? [variation.value.ssml_message] : []
                        content {
                          value = ssml_message.value.value
                        }
                      }
                    }
                  }
                }
              }
            }
          }

          dynamic "update_response" {
            for_each = fulfillment_updates_specification.value.update_response != null ? [fulfillment_updates_specification.value.update_response] : []
            content {
              frequency_in_seconds = update_response.value.frequency_in_seconds
              allow_interrupt      = update_response.value.allow_interrupt

              dynamic "message_group" {
                for_each = update_response.value.message_group
                content {
                  dynamic "message" {
                    for_each = [message_group.value.message]
                    content {
                      dynamic "custom_payload" {
                        for_each = message.value.custom_payload != null ? [message.value.custom_payload] : []
                        content {
                          value = custom_payload.value.value
                        }
                      }

                      dynamic "image_response_card" {
                        for_each = message.value.image_response_card != null ? [message.value.image_response_card] : []
                        content {
                          title     = image_response_card.value.title
                          image_url = image_response_card.value.image_url
                          subtitle  = image_response_card.value.subtitle

                          dynamic "button" {
                            for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                            content {
                              text  = button.value.text
                              value = button.value.value
                            }
                          }
                        }
                      }

                      dynamic "plain_text_message" {
                        for_each = message.value.plain_text_message != null ? [message.value.plain_text_message] : []
                        content {
                          value = plain_text_message.value.value
                        }
                      }

                      dynamic "ssml_message" {
                        for_each = message.value.ssml_message != null ? [message.value.ssml_message] : []
                        content {
                          value = ssml_message.value.value
                        }
                      }
                    }
                  }

                  dynamic "variation" {
                    for_each = message_group.value.variation != null ? message_group.value.variation : []
                    content {
                      dynamic "custom_payload" {
                        for_each = variation.value.custom_payload != null ? [variation.value.custom_payload] : []
                        content {
                          value = custom_payload.value.value
                        }
                      }

                      dynamic "image_response_card" {
                        for_each = variation.value.image_response_card != null ? [variation.value.image_response_card] : []
                        content {
                          title     = image_response_card.value.title
                          image_url = image_response_card.value.image_url
                          subtitle  = image_response_card.value.subtitle

                          dynamic "button" {
                            for_each = image_response_card.value.button != null ? image_response_card.value.button : []
                            content {
                              text  = button.value.text
                              value = button.value.value
                            }
                          }
                        }
                      }

                      dynamic "plain_text_message" {
                        for_each = variation.value.plain_text_message != null ? [variation.value.plain_text_message] : []
                        content {
                          value = plain_text_message.value.value
                        }
                      }

                      dynamic "ssml_message" {
                        for_each = variation.value.ssml_message != null ? [variation.value.ssml_message] : []
                        content {
                          value = ssml_message.value.value
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

      # Add post_fulfillment_status_specification blocks...
    }
  }

  # Add remaining dynamic blocks for other optional configurations
  # initial_response_setting, input_context, kendra_configuration, output_context, sample_utterance, slot_priority

  dynamic "initial_response_setting" {
    for_each = var.initial_response_setting != null ? [var.initial_response_setting] : []
    content {
      # Add initial_response_setting content
    }
  }

  dynamic "input_context" {
    for_each = var.input_context
    content {
      name = input_context.value.name
    }
  }

  dynamic "kendra_configuration" {
    for_each = var.kendra_configuration != null ? [var.kendra_configuration] : []
    content {
      kendra_index                = kendra_configuration.value.kendra_index
      query_filter_string         = kendra_configuration.value.query_filter_string
      query_filter_string_enabled = kendra_configuration.value.query_filter_string_enabled
    }
  }

  dynamic "output_context" {
    for_each = var.output_context
    content {
      name                    = output_context.value.name
      time_to_live_in_seconds = output_context.value.time_to_live_in_seconds
      turns_to_live           = output_context.value.turns_to_live
    }
  }

  dynamic "sample_utterance" {
    for_each = var.sample_utterance
    content {
      utterance = sample_utterance.value.utterance
    }
  }

  dynamic "slot_priority" {
    for_each = var.slot_priority
    content {
      priority = slot_priority.value.priority
      slot_id  = slot_priority.value.slot_id
    }
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}