resource "aws_lexv2models_slot" "this" {
  bot_id      = var.bot_id
  bot_version = var.bot_version
  intent_id   = var.intent_id
  locale_id   = var.locale_id
  name        = var.name

  dynamic "value_elicitation_setting" {
    for_each = [var.value_elicitation_setting]
    content {
      slot_constraint = value_elicitation_setting.value.slot_constraint

      dynamic "default_value_specification" {
        for_each = value_elicitation_setting.value.default_value_specification != null ? [value_elicitation_setting.value.default_value_specification] : []
        content {
          dynamic "default_value_list" {
            for_each = default_value_specification.value.default_value_list
            content {
              default_value = default_value_list.value.default_value
            }
          }
        }
      }

      dynamic "prompt_specification" {
        for_each = value_elicitation_setting.value.prompt_specification != null ? [value_elicitation_setting.value.prompt_specification] : []
        content {
          allow_interrupt            = prompt_specification.value.allow_interrupt
          max_retries                = prompt_specification.value.max_retries
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
                      subtitle  = image_response_card.value.subtitle
                      image_url = image_response_card.value.image_url

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
                      subtitle  = image_response_card.value.subtitle
                      image_url = image_response_card.value.image_url

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
              allow_interrupt = prompt_attempts_specification.value.allow_interrupt
              map_block_key   = prompt_attempts_specification.value.map_block_key

              dynamic "allowed_input_types" {
                for_each = prompt_attempts_specification.value.allowed_input_types != null ? [prompt_attempts_specification.value.allowed_input_types] : []
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


      dynamic "slot_resolution_setting" {
        for_each = value_elicitation_setting.value.slot_resolution_setting != null ? [value_elicitation_setting.value.slot_resolution_setting] : []
        content {
          slot_resolution_strategy = slot_resolution_setting.value.slot_resolution_strategy
        }
      }

      dynamic "wait_and_continue_specification" {
        for_each = value_elicitation_setting.value.wait_and_continue_specification != null ? [value_elicitation_setting.value.wait_and_continue_specification] : []
        content {
          active = wait_and_continue_specification.value.active

          dynamic "continue_response" {
            for_each = [wait_and_continue_specification.value.continue_response]
            content {
              allow_interrupt = continue_response.value.allow_interrupt

              dynamic "message_group" {
                for_each = continue_response.value.message_group
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
                          subtitle  = image_response_card.value.subtitle
                          image_url = image_response_card.value.image_url

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
                          subtitle  = image_response_card.value.subtitle
                          image_url = image_response_card.value.image_url

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

          dynamic "waiting_response" {
            for_each = [wait_and_continue_specification.value.waiting_response]
            content {
              allow_interrupt = waiting_response.value.allow_interrupt

              dynamic "message_group" {
                for_each = waiting_response.value.message_group
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
                          subtitle  = image_response_card.value.subtitle
                          image_url = image_response_card.value.image_url

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
                          subtitle  = image_response_card.value.subtitle
                          image_url = image_response_card.value.image_url

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

          dynamic "still_waiting_response" {
            for_each = wait_and_continue_specification.value.still_waiting_response != null ? [wait_and_continue_specification.value.still_waiting_response] : []
            content {
              allow_interrupt      = still_waiting_response.value.allow_interrupt
              frequency_in_seconds = still_waiting_response.value.frequency_in_seconds
              timeout_in_seconds   = still_waiting_response.value.timeout_in_seconds

              dynamic "message_group" {
                for_each = still_waiting_response.value.message_group
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
                          subtitle  = image_response_card.value.subtitle
                          image_url = image_response_card.value.image_url

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
                          subtitle  = image_response_card.value.subtitle
                          image_url = image_response_card.value.image_url

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

  region       = var.region
  description  = var.description
  slot_type_id = var.slot_type_id

  dynamic "multiple_values_setting" {
    for_each = var.multiple_values_setting != null ? [var.multiple_values_setting] : []
    content {
      allow_multiple_values = multiple_values_setting.value.allow_multiple_values
    }
  }

  dynamic "obfuscation_setting" {
    for_each = var.obfuscation_setting != null ? [var.obfuscation_setting] : []
    content {
      obfuscation_setting_type = obfuscation_setting.value.obfuscation_setting_type
    }
  }

  dynamic "sub_slot_setting" {
    for_each = var.sub_slot_setting != null ? [var.sub_slot_setting] : []
    content {
      expression = sub_slot_setting.value.expression

      dynamic "slot_specification" {
        for_each = sub_slot_setting.value.slot_specification != null ? sub_slot_setting.value.slot_specification : []
        content {
          map_block_key = slot_specification.key
          slot_type_id  = slot_specification.value.slot_type_id

          dynamic "value_elicitation_setting" {
            for_each = [slot_specification.value.value_elicitation_setting]
            content {
              dynamic "default_value_specification" {
                for_each = value_elicitation_setting.value.default_value_specification != null ? [value_elicitation_setting.value.default_value_specification] : []
                content {
                  dynamic "default_value_list" {
                    for_each = default_value_specification.value.default_value_list
                    content {
                      default_value = default_value_list.value.default_value
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