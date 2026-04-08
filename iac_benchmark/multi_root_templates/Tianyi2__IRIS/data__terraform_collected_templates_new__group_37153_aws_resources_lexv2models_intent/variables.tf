variable "bot_id" {
  description = "Identifier of the bot associated with this intent."
  type        = string

  validation {
    condition     = length(var.bot_id) > 0
    error_message = "resource_aws_lexv2models_intent, bot_id must be a non-empty string."
  }
}

variable "bot_version" {
  description = "Version of the bot associated with this intent."
  type        = string

  validation {
    condition     = length(var.bot_version) > 0
    error_message = "resource_aws_lexv2models_intent, bot_version must be a non-empty string."
  }
}

variable "locale_id" {
  description = "Identifier of the language and locale where this intent is used. All of the bots, slot types, and slots used by the intent must have the same locale."
  type        = string

  validation {
    condition     = length(var.locale_id) > 0
    error_message = "resource_aws_lexv2models_intent, locale_id must be a non-empty string."
  }
}

variable "name" {
  description = "Name of the intent. Intent names must be unique in the locale that contains the intent and cannot match the name of any built-in intent."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_lexv2models_intent, name must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "closing_setting" {
  description = "Configuration block for the response that Amazon Lex sends to the user when the intent is closed."
  type = object({
    active = optional(bool)
    closing_response = optional(object({
      message_group = list(object({
        message = object({
          custom_payload = optional(object({
            value = string
          }))
          image_response_card = optional(object({
            title = string
            button = optional(list(object({
              text  = string
              value = string
            })))
            image_url = optional(string)
            subtitle  = optional(string)
          }))
          plain_text_message = optional(object({
            value = string
          }))
          ssml_message = optional(object({
            value = string
          }))
        })
        variation = optional(list(object({
          custom_payload = optional(object({
            value = string
          }))
          image_response_card = optional(object({
            title = string
            button = optional(list(object({
              text  = string
              value = string
            })))
            image_url = optional(string)
            subtitle  = optional(string)
          }))
          plain_text_message = optional(object({
            value = string
          }))
          ssml_message = optional(object({
            value = string
          }))
        })))
      }))
      allow_interrupt = optional(bool)
    }))
    conditional = optional(object({
      active = bool
      conditional_branch = list(object({
        condition = object({
          expression_string = string
        })
        name = string
        next_step = object({
          dialog_action = optional(object({
            type                  = string
            slot_to_elicit        = optional(string)
            suppress_next_message = optional(bool)
          }))
          intent = optional(object({
            name = optional(string)
            slot = optional(map(object({
              shape = optional(string)
              value = optional(object({
                interpreted_value = optional(string)
              }))
            })))
          }))
          session_attributes = optional(map(string))
        })
        response = optional(object({
          message_group = list(object({
            message = object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })
            variation = optional(list(object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })))
          }))
          allow_interrupt = optional(bool)
        }))
      }))
      default_branch = object({
        next_step = object({
          dialog_action = optional(object({
            type                  = string
            slot_to_elicit        = optional(string)
            suppress_next_message = optional(bool)
          }))
          intent = optional(object({
            name = optional(string)
            slot = optional(map(object({
              shape = optional(string)
              value = optional(object({
                interpreted_value = optional(string)
              }))
            })))
          }))
          session_attributes = optional(map(string))
        })
        response = optional(object({
          message_group = list(object({
            message = object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })
            variation = optional(list(object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })))
          }))
          allow_interrupt = optional(bool)
        }))
      })
    }))
    next_step = optional(object({
      dialog_action = optional(object({
        type                  = string
        slot_to_elicit        = optional(string)
        suppress_next_message = optional(bool)
      }))
      intent = optional(object({
        name = optional(string)
        slot = optional(map(object({
          shape = optional(string)
          value = optional(object({
            interpreted_value = optional(string)
          }))
        })))
      }))
      session_attributes = optional(map(string))
    }))
  })
  default = null

  validation {
    condition = var.closing_setting == null ? true : (
      var.closing_setting.conditional == null ? true : (
        contains(["ElicitIntent", "StartIntent", "ElicitSlot", "EvaluateConditional", "InvokeDialogCodeHook", "ConfirmIntent", "FulfillIntent", "CloseIntent", "EndConversation"],
        try(var.closing_setting.conditional.default_branch.next_step.dialog_action.type, "ElicitIntent"))
      )
    )
    error_message = "resource_aws_lexv2models_intent, closing_setting.conditional.default_branch.next_step.dialog_action.type must be one of: ElicitIntent, StartIntent, ElicitSlot, EvaluateConditional, InvokeDialogCodeHook, ConfirmIntent, FulfillIntent, CloseIntent, EndConversation."
  }
}

variable "confirmation_setting" {
  description = "Configuration block for prompts that Amazon Lex sends to the user to confirm the completion of an intent."
  type = object({
    prompt_specification = object({
      max_retries = number
      message_group = list(object({
        message = object({
          custom_payload = optional(object({
            value = string
          }))
          image_response_card = optional(object({
            title = string
            button = optional(list(object({
              text  = string
              value = string
            })))
            image_url = optional(string)
            subtitle  = optional(string)
          }))
          plain_text_message = optional(object({
            value = string
          }))
          ssml_message = optional(object({
            value = string
          }))
        })
        variation = optional(list(object({
          custom_payload = optional(object({
            value = string
          }))
          image_response_card = optional(object({
            title = string
            button = optional(list(object({
              text  = string
              value = string
            })))
            image_url = optional(string)
            subtitle  = optional(string)
          }))
          plain_text_message = optional(object({
            value = string
          }))
          ssml_message = optional(object({
            value = string
          }))
        })))
      }))
      allow_interrupt            = optional(bool)
      message_selection_strategy = optional(string)
      prompt_attempts_specification = optional(list(object({
        allowed_input_types = object({
          allow_audio_input = bool
          allow_dtmf_input  = bool
        })
        map_block_key   = string
        allow_interrupt = optional(bool)
        audio_and_dtmf_input_specification = optional(object({
          start_timeout_ms = number
          audio_specification = optional(object({
            end_timeout_ms = number
            max_length_ms  = number
          }))
          dtmf_specification = optional(object({
            deletion_character = string
            end_character      = string
            end_timeout_ms     = number
            max_length         = number
          }))
        }))
        text_input_specification = optional(object({
          start_timeout_ms = number
        }))
      })))
    })
    active = optional(bool)
    code_hook = optional(object({
      active                      = bool
      enable_code_hook_invocation = bool
      post_code_hook_specification = object({
        failure_conditional = optional(object({
          active = bool
          conditional_branch = list(object({
            condition = object({
              expression_string = string
            })
            name = string
            next_step = object({
              dialog_action = optional(object({
                type                  = string
                slot_to_elicit        = optional(string)
                suppress_next_message = optional(bool)
              }))
              intent = optional(object({
                name = optional(string)
                slot = optional(map(object({
                  shape = optional(string)
                  value = optional(object({
                    interpreted_value = optional(string)
                  }))
                })))
              }))
              session_attributes = optional(map(string))
            })
            response = optional(object({
              message_group = list(object({
                message = object({
                  custom_payload = optional(object({
                    value = string
                  }))
                  image_response_card = optional(object({
                    title = string
                    button = optional(list(object({
                      text  = string
                      value = string
                    })))
                    image_url = optional(string)
                    subtitle  = optional(string)
                  }))
                  plain_text_message = optional(object({
                    value = string
                  }))
                  ssml_message = optional(object({
                    value = string
                  }))
                })
                variation = optional(list(object({
                  custom_payload = optional(object({
                    value = string
                  }))
                  image_response_card = optional(object({
                    title = string
                    button = optional(list(object({
                      text  = string
                      value = string
                    })))
                    image_url = optional(string)
                    subtitle  = optional(string)
                  }))
                  plain_text_message = optional(object({
                    value = string
                  }))
                  ssml_message = optional(object({
                    value = string
                  }))
                })))
              }))
              allow_interrupt = optional(bool)
            }))
          }))
          default_branch = object({
            next_step = object({
              dialog_action = optional(object({
                type                  = string
                slot_to_elicit        = optional(string)
                suppress_next_message = optional(bool)
              }))
              intent = optional(object({
                name = optional(string)
                slot = optional(map(object({
                  shape = optional(string)
                  value = optional(object({
                    interpreted_value = optional(string)
                  }))
                })))
              }))
              session_attributes = optional(map(string))
            })
            response = optional(object({
              message_group = list(object({
                message = object({
                  custom_payload = optional(object({
                    value = string
                  }))
                  image_response_card = optional(object({
                    title = string
                    button = optional(list(object({
                      text  = string
                      value = string
                    })))
                    image_url = optional(string)
                    subtitle  = optional(string)
                  }))
                  plain_text_message = optional(object({
                    value = string
                  }))
                  ssml_message = optional(object({
                    value = string
                  }))
                })
                variation = optional(list(object({
                  custom_payload = optional(object({
                    value = string
                  }))
                  image_response_card = optional(object({
                    title = string
                    button = optional(list(object({
                      text  = string
                      value = string
                    })))
                    image_url = optional(string)
                    subtitle  = optional(string)
                  }))
                  plain_text_message = optional(object({
                    value = string
                  }))
                  ssml_message = optional(object({
                    value = string
                  }))
                })))
              }))
              allow_interrupt = optional(bool)
            }))
          })
        }))
        failure_next_step = optional(object({
          dialog_action = optional(object({
            type                  = string
            slot_to_elicit        = optional(string)
            suppress_next_message = optional(bool)
          }))
          intent = optional(object({
            name = optional(string)
            slot = optional(map(object({
              shape = optional(string)
              value = optional(object({
                interpreted_value = optional(string)
              }))
            })))
          }))
          session_attributes = optional(map(string))
        }))
        failure_response = optional(object({
          message_group = list(object({
            message = object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })
            variation = optional(list(object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })))
          }))
          allow_interrupt = optional(bool)
        }))
        success_conditional = optional(object({
          active = bool
          conditional_branch = list(object({
            condition = object({
              expression_string = string
            })
            name = string
            next_step = object({
              dialog_action = optional(object({
                type                  = string
                slot_to_elicit        = optional(string)
                suppress_next_message = optional(bool)
              }))
              intent = optional(object({
                name = optional(string)
                slot = optional(map(object({
                  shape = optional(string)
                  value = optional(object({
                    interpreted_value = optional(string)
                  }))
                })))
              }))
              session_attributes = optional(map(string))
            })
            response = optional(object({
              message_group = list(object({
                message = object({
                  custom_payload = optional(object({
                    value = string
                  }))
                  image_response_card = optional(object({
                    title = string
                    button = optional(list(object({
                      text  = string
                      value = string
                    })))
                    image_url = optional(string)
                    subtitle  = optional(string)
                  }))
                  plain_text_message = optional(object({
                    value = string
                  }))
                  ssml_message = optional(object({
                    value = string
                  }))
                })
                variation = optional(list(object({
                  custom_payload = optional(object({
                    value = string
                  }))
                  image_response_card = optional(object({
                    title = string
                    button = optional(list(object({
                      text  = string
                      value = string
                    })))
                    image_url = optional(string)
                    subtitle  = optional(string)
                  }))
                  plain_text_message = optional(object({
                    value = string
                  }))
                  ssml_message = optional(object({
                    value = string
                  }))
                })))
              }))
              allow_interrupt = optional(bool)
            }))
          }))
          default_branch = object({
            next_step = object({
              dialog_action = optional(object({
                type                  = string
                slot_to_elicit        = optional(string)
                suppress_next_message = optional(bool)
              }))
              intent = optional(object({
                name = optional(string)
                slot = optional(map(object({
                  shape = optional(string)
                  value = optional(object({
                    interpreted_value = optional(string)
                  }))
                })))
              }))
              session_attributes = optional(map(string))
            })
            response = optional(object({
              message_group = list(object({
                message = object({
                  custom_payload = optional(object({
                    value = string
                  }))
                  image_response_card = optional(object({
                    title = string
                    button = optional(list(object({
                      text  = string
                      value = string
                    })))
                    image_url = optional(string)
                    subtitle  = optional(string)
                  }))
                  plain_text_message = optional(object({
                    value = string
                  }))
                  ssml_message = optional(object({
                    value = string
                  }))
                })
                variation = optional(list(object({
                  custom_payload = optional(object({
                    value = string
                  }))
                  image_response_card = optional(object({
                    title = string
                    button = optional(list(object({
                      text  = string
                      value = string
                    })))
                    image_url = optional(string)
                    subtitle  = optional(string)
                  }))
                  plain_text_message = optional(object({
                    value = string
                  }))
                  ssml_message = optional(object({
                    value = string
                  }))
                })))
              }))
              allow_interrupt = optional(bool)
            }))
          })
        }))
        success_next_step = optional(object({
          dialog_action = optional(object({
            type                  = string
            slot_to_elicit        = optional(string)
            suppress_next_message = optional(bool)
          }))
          intent = optional(object({
            name = optional(string)
            slot = optional(map(object({
              shape = optional(string)
              value = optional(object({
                interpreted_value = optional(string)
              }))
            })))
          }))
          session_attributes = optional(map(string))
        }))
        success_response = optional(object({
          message_group = list(object({
            message = object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })
            variation = optional(list(object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })))
          }))
          allow_interrupt = optional(bool)
        }))
        timeout_conditional = optional(object({
          active = bool
          conditional_branch = list(object({
            condition = object({
              expression_string = string
            })
            name = string
            next_step = object({
              dialog_action = optional(object({
                type                  = string
                slot_to_elicit        = optional(string)
                suppress_next_message = optional(bool)
              }))
              intent = optional(object({
                name = optional(string)
                slot = optional(map(object({
                  shape = optional(string)
                  value = optional(object({
                    interpreted_value = optional(string)
                  }))
                })))
              }))
              session_attributes = optional(map(string))
            })
            response = optional(object({
              message_group = list(object({
                message = object({
                  custom_payload = optional(object({
                    value = string
                  }))
                  image_response_card = optional(object({
                    title = string
                    button = optional(list(object({
                      text  = string
                      value = string
                    })))
                    image_url = optional(string)
                    subtitle  = optional(string)
                  }))
                  plain_text_message = optional(object({
                    value = string
                  }))
                  ssml_message = optional(object({
                    value = string
                  }))
                })
                variation = optional(list(object({
                  custom_payload = optional(object({
                    value = string
                  }))
                  image_response_card = optional(object({
                    title = string
                    button = optional(list(object({
                      text  = string
                      value = string
                    })))
                    image_url = optional(string)
                    subtitle  = optional(string)
                  }))
                  plain_text_message = optional(object({
                    value = string
                  }))
                  ssml_message = optional(object({
                    value = string
                  }))
                })))
              }))
              allow_interrupt = optional(bool)
            }))
          }))
          default_branch = object({
            next_step = object({
              dialog_action = optional(object({
                type                  = string
                slot_to_elicit        = optional(string)
                suppress_next_message = optional(bool)
              }))
              intent = optional(object({
                name = optional(string)
                slot = optional(map(object({
                  shape = optional(string)
                  value = optional(object({
                    interpreted_value = optional(string)
                  }))
                })))
              }))
              session_attributes = optional(map(string))
            })
            response = optional(object({
              message_group = list(object({
                message = object({
                  custom_payload = optional(object({
                    value = string
                  }))
                  image_response_card = optional(object({
                    title = string
                    button = optional(list(object({
                      text  = string
                      value = string
                    })))
                    image_url = optional(string)
                    subtitle  = optional(string)
                  }))
                  plain_text_message = optional(object({
                    value = string
                  }))
                  ssml_message = optional(object({
                    value = string
                  }))
                })
                variation = optional(list(object({
                  custom_payload = optional(object({
                    value = string
                  }))
                  image_response_card = optional(object({
                    title = string
                    button = optional(list(object({
                      text  = string
                      value = string
                    })))
                    image_url = optional(string)
                    subtitle  = optional(string)
                  }))
                  plain_text_message = optional(object({
                    value = string
                  }))
                  ssml_message = optional(object({
                    value = string
                  }))
                })))
              }))
              allow_interrupt = optional(bool)
            }))
          })
        }))
        timeout_next_step = optional(object({
          dialog_action = optional(object({
            type                  = string
            slot_to_elicit        = optional(string)
            suppress_next_message = optional(bool)
          }))
          intent = optional(object({
            name = optional(string)
            slot = optional(map(object({
              shape = optional(string)
              value = optional(object({
                interpreted_value = optional(string)
              }))
            })))
          }))
          session_attributes = optional(map(string))
        }))
        timeout_response = optional(object({
          message_group = list(object({
            message = object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })
            variation = optional(list(object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })))
          }))
          allow_interrupt = optional(bool)
        }))
      })
      invocation_label = optional(string)
    }))
    confirmation_conditional = optional(object({
      active = bool
      conditional_branch = list(object({
        condition = object({
          expression_string = string
        })
        name = string
        next_step = object({
          dialog_action = optional(object({
            type                  = string
            slot_to_elicit        = optional(string)
            suppress_next_message = optional(bool)
          }))
          intent = optional(object({
            name = optional(string)
            slot = optional(map(object({
              shape = optional(string)
              value = optional(object({
                interpreted_value = optional(string)
              }))
            })))
          }))
          session_attributes = optional(map(string))
        })
        response = optional(object({
          message_group = list(object({
            message = object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })
            variation = optional(list(object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })))
          }))
          allow_interrupt = optional(bool)
        }))
      }))
      default_branch = object({
        next_step = object({
          dialog_action = optional(object({
            type                  = string
            slot_to_elicit        = optional(string)
            suppress_next_message = optional(bool)
          }))
          intent = optional(object({
            name = optional(string)
            slot = optional(map(object({
              shape = optional(string)
              value = optional(object({
                interpreted_value = optional(string)
              }))
            })))
          }))
          session_attributes = optional(map(string))
        })
        response = optional(object({
          message_group = list(object({
            message = object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })
            variation = optional(list(object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })))
          }))
          allow_interrupt = optional(bool)
        }))
      })
    }))
    confirmation_next_step = optional(object({
      dialog_action = optional(object({
        type                  = string
        slot_to_elicit        = optional(string)
        suppress_next_message = optional(bool)
      }))
      intent = optional(object({
        name = optional(string)
        slot = optional(map(object({
          shape = optional(string)
          value = optional(object({
            interpreted_value = optional(string)
          }))
        })))
      }))
      session_attributes = optional(map(string))
    }))
    confirmation_response = optional(object({
      message_group = list(object({
        message = object({
          custom_payload = optional(object({
            value = string
          }))
          image_response_card = optional(object({
            title = string
            button = optional(list(object({
              text  = string
              value = string
            })))
            image_url = optional(string)
            subtitle  = optional(string)
          }))
          plain_text_message = optional(object({
            value = string
          }))
          ssml_message = optional(object({
            value = string
          }))
        })
        variation = optional(list(object({
          custom_payload = optional(object({
            value = string
          }))
          image_response_card = optional(object({
            title = string
            button = optional(list(object({
              text  = string
              value = string
            })))
            image_url = optional(string)
            subtitle  = optional(string)
          }))
          plain_text_message = optional(object({
            value = string
          }))
          ssml_message = optional(object({
            value = string
          }))
        })))
      }))
      allow_interrupt = optional(bool)
    }))
    declination_conditional = optional(object({
      active = bool
      conditional_branch = list(object({
        condition = object({
          expression_string = string
        })
        name = string
        next_step = object({
          dialog_action = optional(object({
            type                  = string
            slot_to_elicit        = optional(string)
            suppress_next_message = optional(bool)
          }))
          intent = optional(object({
            name = optional(string)
            slot = optional(map(object({
              shape = optional(string)
              value = optional(object({
                interpreted_value = optional(string)
              }))
            })))
          }))
          session_attributes = optional(map(string))
        })
        response = optional(object({
          message_group = list(object({
            message = object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })
            variation = optional(list(object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })))
          }))
          allow_interrupt = optional(bool)
        }))
      }))
      default_branch = object({
        next_step = object({
          dialog_action = optional(object({
            type                  = string
            slot_to_elicit        = optional(string)
            suppress_next_message = optional(bool)
          }))
          intent = optional(object({
            name = optional(string)
            slot = optional(map(object({
              shape = optional(string)
              value = optional(object({
                interpreted_value = optional(string)
              }))
            })))
          }))
          session_attributes = optional(map(string))
        })
        response = optional(object({
          message_group = list(object({
            message = object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })
            variation = optional(list(object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })))
          }))
          allow_interrupt = optional(bool)
        }))
      })
    }))
    declination_next_step = optional(object({
      dialog_action = optional(object({
        type                  = string
        slot_to_elicit        = optional(string)
        suppress_next_message = optional(bool)
      }))
      intent = optional(object({
        name = optional(string)
        slot = optional(map(object({
          shape = optional(string)
          value = optional(object({
            interpreted_value = optional(string)
          }))
        })))
      }))
      session_attributes = optional(map(string))
    }))
    declination_response = optional(object({
      message_group = list(object({
        message = object({
          custom_payload = optional(object({
            value = string
          }))
          image_response_card = optional(object({
            title = string
            button = optional(list(object({
              text  = string
              value = string
            })))
            image_url = optional(string)
            subtitle  = optional(string)
          }))
          plain_text_message = optional(object({
            value = string
          }))
          ssml_message = optional(object({
            value = string
          }))
        })
        variation = optional(list(object({
          custom_payload = optional(object({
            value = string
          }))
          image_response_card = optional(object({
            title = string
            button = optional(list(object({
              text  = string
              value = string
            })))
            image_url = optional(string)
            subtitle  = optional(string)
          }))
          plain_text_message = optional(object({
            value = string
          }))
          ssml_message = optional(object({
            value = string
          }))
        })))
      }))
      allow_interrupt = optional(bool)
    }))
    elicitation_code_hook = optional(object({
      enable_code_hook_invocation = bool
      invocation_label            = optional(string)
    }))
    failure_conditional = optional(object({
      active = bool
      conditional_branch = list(object({
        condition = object({
          expression_string = string
        })
        name = string
        next_step = object({
          dialog_action = optional(object({
            type                  = string
            slot_to_elicit        = optional(string)
            suppress_next_message = optional(bool)
          }))
          intent = optional(object({
            name = optional(string)
            slot = optional(map(object({
              shape = optional(string)
              value = optional(object({
                interpreted_value = optional(string)
              }))
            })))
          }))
          session_attributes = optional(map(string))
        })
        response = optional(object({
          message_group = list(object({
            message = object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })
            variation = optional(list(object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })))
          }))
          allow_interrupt = optional(bool)
        }))
      }))
      default_branch = object({
        next_step = object({
          dialog_action = optional(object({
            type                  = string
            slot_to_elicit        = optional(string)
            suppress_next_message = optional(bool)
          }))
          intent = optional(object({
            name = optional(string)
            slot = optional(map(object({
              shape = optional(string)
              value = optional(object({
                interpreted_value = optional(string)
              }))
            })))
          }))
          session_attributes = optional(map(string))
        })
        response = optional(object({
          message_group = list(object({
            message = object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })
            variation = optional(list(object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })))
          }))
          allow_interrupt = optional(bool)
        }))
      })
    }))
    failure_next_step = optional(object({
      dialog_action = optional(object({
        type                  = string
        slot_to_elicit        = optional(string)
        suppress_next_message = optional(bool)
      }))
      intent = optional(object({
        name = optional(string)
        slot = optional(map(object({
          shape = optional(string)
          value = optional(object({
            interpreted_value = optional(string)
          }))
        })))
      }))
      session_attributes = optional(map(string))
    }))
    failure_response = optional(object({
      message_group = list(object({
        message = object({
          custom_payload = optional(object({
            value = string
          }))
          image_response_card = optional(object({
            title = string
            button = optional(list(object({
              text  = string
              value = string
            })))
            image_url = optional(string)
            subtitle  = optional(string)
          }))
          plain_text_message = optional(object({
            value = string
          }))
          ssml_message = optional(object({
            value = string
          }))
        })
        variation = optional(list(object({
          custom_payload = optional(object({
            value = string
          }))
          image_response_card = optional(object({
            title = string
            button = optional(list(object({
              text  = string
              value = string
            })))
            image_url = optional(string)
            subtitle  = optional(string)
          }))
          plain_text_message = optional(object({
            value = string
          }))
          ssml_message = optional(object({
            value = string
          }))
        })))
      }))
      allow_interrupt = optional(bool)
    }))
  })
  default = null

  validation {
    condition = var.confirmation_setting == null ? true : (
      contains(["Random", "Ordered"],
      try(var.confirmation_setting.prompt_specification.message_selection_strategy, "Random"))
    )
    error_message = "resource_aws_lexv2models_intent, confirmation_setting.prompt_specification.message_selection_strategy must be either 'Random' or 'Ordered'."
  }

  validation {
    condition = var.confirmation_setting == null ? true : (
      var.confirmation_setting.prompt_specification.prompt_attempts_specification == null ? true :
      alltrue([
        for spec in var.confirmation_setting.prompt_specification.prompt_attempts_specification :
        contains(["Initial", "Retry1", "Retry2", "Retry3", "Retry4", "Retry5"], spec.map_block_key)
      ])
    )
    error_message = "resource_aws_lexv2models_intent, confirmation_setting.prompt_specification.prompt_attempts_specification.map_block_key must be one of: Initial, Retry1, Retry2, Retry3, Retry4, Retry5."
  }
}

variable "description" {
  description = "Description of the intent. Use the description to help identify the intent in lists."
  type        = string
  default     = null
}

variable "dialog_code_hook" {
  description = "Configuration block for invoking the alias Lambda function for each user input."
  type = object({
    enabled = bool
  })
  default = null
}

variable "fulfillment_code_hook" {
  description = "Configuration block for invoking the alias Lambda function when the intent is ready for fulfillment."
  type = object({
    enabled = bool
    active  = optional(bool)
    fulfillment_updates_specification = optional(object({
      active = bool
      start_response = optional(object({
        delay_in_seconds = number
        message_group = list(object({
          message = object({
            custom_payload = optional(object({
              value = string
            }))
            image_response_card = optional(object({
              title = string
              button = optional(list(object({
                text  = string
                value = string
              })))
              image_url = optional(string)
              subtitle  = optional(string)
            }))
            plain_text_message = optional(object({
              value = string
            }))
            ssml_message = optional(object({
              value = string
            }))
          })
          variation = optional(list(object({
            custom_payload = optional(object({
              value = string
            }))
            image_response_card = optional(object({
              title = string
              button = optional(list(object({
                text  = string
                value = string
              })))
              image_url = optional(string)
              subtitle  = optional(string)
            }))
            plain_text_message = optional(object({
              value = string
            }))
            ssml_message = optional(object({
              value = string
            }))
          })))
        }))
        allow_interrupt = optional(bool)
      }))
      timeout_in_seconds = optional(number)
      update_response = optional(object({
        frequency_in_seconds = number
        message_group = list(object({
          message = object({
            custom_payload = optional(object({
              value = string
            }))
            image_response_card = optional(object({
              title = string
              button = optional(list(object({
                text  = string
                value = string
              })))
              image_url = optional(string)
              subtitle  = optional(string)
            }))
            plain_text_message = optional(object({
              value = string
            }))
            ssml_message = optional(object({
              value = string
            }))
          })
          variation = optional(list(object({
            custom_payload = optional(object({
              value = string
            }))
            image_response_card = optional(object({
              title = string
              button = optional(list(object({
                text  = string
                value = string
              })))
              image_url = optional(string)
              subtitle  = optional(string)
            }))
            plain_text_message = optional(object({
              value = string
            }))
            ssml_message = optional(object({
              value = string
            }))
          })))
        }))
        allow_interrupt = optional(bool)
      }))
    }))
    post_fulfillment_status_specification = optional(object({
      failure_conditional = optional(object({
        active = bool
        conditional_branch = list(object({
          condition = object({
            expression_string = string
          })
          name = string
          next_step = object({
            dialog_action = optional(object({
              type                  = string
              slot_to_elicit        = optional(string)
              suppress_next_message = optional(bool)
            }))
            intent = optional(object({
              name = optional(string)
              slot = optional(map(object({
                shape = optional(string)
                value = optional(object({
                  interpreted_value = optional(string)
                }))
              })))
            }))
            session_attributes = optional(map(string))
          })
          response = optional(object({
            message_group = list(object({
              message = object({
                custom_payload = optional(object({
                  value = string
                }))
                image_response_card = optional(object({
                  title = string
                  button = optional(list(object({
                    text  = string
                    value = string
                  })))
                  image_url = optional(string)
                  subtitle  = optional(string)
                }))
                plain_text_message = optional(object({
                  value = string
                }))
                ssml_message = optional(object({
                  value = string
                }))
              })
              variation = optional(list(object({
                custom_payload = optional(object({
                  value = string
                }))
                image_response_card = optional(object({
                  title = string
                  button = optional(list(object({
                    text  = string
                    value = string
                  })))
                  image_url = optional(string)
                  subtitle  = optional(string)
                }))
                plain_text_message = optional(object({
                  value = string
                }))
                ssml_message = optional(object({
                  value = string
                }))
              })))
            }))
            allow_interrupt = optional(bool)
          }))
        }))
        default_branch = object({
          next_step = object({
            dialog_action = optional(object({
              type                  = string
              slot_to_elicit        = optional(string)
              suppress_next_message = optional(bool)
            }))
            intent = optional(object({
              name = optional(string)
              slot = optional(map(object({
                shape = optional(string)
                value = optional(object({
                  interpreted_value = optional(string)
                }))
              })))
            }))
            session_attributes = optional(map(string))
          })
          response = optional(object({
            message_group = list(object({
              message = object({
                custom_payload = optional(object({
                  value = string
                }))
                image_response_card = optional(object({
                  title = string
                  button = optional(list(object({
                    text  = string
                    value = string
                  })))
                  image_url = optional(string)
                  subtitle  = optional(string)
                }))
                plain_text_message = optional(object({
                  value = string
                }))
                ssml_message = optional(object({
                  value = string
                }))
              })
              variation = optional(list(object({
                custom_payload = optional(object({
                  value = string
                }))
                image_response_card = optional(object({
                  title = string
                  button = optional(list(object({
                    text  = string
                    value = string
                  })))
                  image_url = optional(string)
                  subtitle  = optional(string)
                }))
                plain_text_message = optional(object({
                  value = string
                }))
                ssml_message = optional(object({
                  value = string
                }))
              })))
            }))
            allow_interrupt = optional(bool)
          }))
        })
      }))
      failure_next_step = optional(object({
        dialog_action = optional(object({
          type                  = string
          slot_to_elicit        = optional(string)
          suppress_next_message = optional(bool)
        }))
        intent = optional(object({
          name = optional(string)
          slot = optional(map(object({
            shape = optional(string)
            value = optional(object({
              interpreted_value = optional(string)
            }))
          })))
        }))
        session_attributes = optional(map(string))
      }))
      failure_response = optional(object({
        message_group = list(object({
          message = object({
            custom_payload = optional(object({
              value = string
            }))
            image_response_card = optional(object({
              title = string
              button = optional(list(object({
                text  = string
                value = string
              })))
              image_url = optional(string)
              subtitle  = optional(string)
            }))
            plain_text_message = optional(object({
              value = string
            }))
            ssml_message = optional(object({
              value = string
            }))
          })
          variation = optional(list(object({
            custom_payload = optional(object({
              value = string
            }))
            image_response_card = optional(object({
              title = string
              button = optional(list(object({
                text  = string
                value = string
              })))
              image_url = optional(string)
              subtitle  = optional(string)
            }))
            plain_text_message = optional(object({
              value = string
            }))
            ssml_message = optional(object({
              value = string
            }))
          })))
        }))
        allow_interrupt = optional(bool)
      }))
      success_conditional = optional(object({
        active = bool
        conditional_branch = list(object({
          condition = object({
            expression_string = string
          })
          name = string
          next_step = object({
            dialog_action = optional(object({
              type                  = string
              slot_to_elicit        = optional(string)
              suppress_next_message = optional(bool)
            }))
            intent = optional(object({
              name = optional(string)
              slot = optional(map(object({
                shape = optional(string)
                value = optional(object({
                  interpreted_value = optional(string)
                }))
              })))
            }))
            session_attributes = optional(map(string))
          })
          response = optional(object({
            message_group = list(object({
              message = object({
                custom_payload = optional(object({
                  value = string
                }))
                image_response_card = optional(object({
                  title = string
                  button = optional(list(object({
                    text  = string
                    value = string
                  })))
                  image_url = optional(string)
                  subtitle  = optional(string)
                }))
                plain_text_message = optional(object({
                  value = string
                }))
                ssml_message = optional(object({
                  value = string
                }))
              })
              variation = optional(list(object({
                custom_payload = optional(object({
                  value = string
                }))
                image_response_card = optional(object({
                  title = string
                  button = optional(list(object({
                    text  = string
                    value = string
                  })))
                  image_url = optional(string)
                  subtitle  = optional(string)
                }))
                plain_text_message = optional(object({
                  value = string
                }))
                ssml_message = optional(object({
                  value = string
                }))
              })))
            }))
            allow_interrupt = optional(bool)
          }))
        }))
        default_branch = object({
          next_step = object({
            dialog_action = optional(object({
              type                  = string
              slot_to_elicit        = optional(string)
              suppress_next_message = optional(bool)
            }))
            intent = optional(object({
              name = optional(string)
              slot = optional(map(object({
                shape = optional(string)
                value = optional(object({
                  interpreted_value = optional(string)
                }))
              })))
            }))
            session_attributes = optional(map(string))
          })
          response = optional(object({
            message_group = list(object({
              message = object({
                custom_payload = optional(object({
                  value = string
                }))
                image_response_card = optional(object({
                  title = string
                  button = optional(list(object({
                    text  = string
                    value = string
                  })))
                  image_url = optional(string)
                  subtitle  = optional(string)
                }))
                plain_text_message = optional(object({
                  value = string
                }))
                ssml_message = optional(object({
                  value = string
                }))
              })
              variation = optional(list(object({
                custom_payload = optional(object({
                  value = string
                }))
                image_response_card = optional(object({
                  title = string
                  button = optional(list(object({
                    text  = string
                    value = string
                  })))
                  image_url = optional(string)
                  subtitle  = optional(string)
                }))
                plain_text_message = optional(object({
                  value = string
                }))
                ssml_message = optional(object({
                  value = string
                }))
              })))
            }))
            allow_interrupt = optional(bool)
          }))
        })
      }))
      success_next_step = optional(object({
        dialog_action = optional(object({
          type                  = string
          slot_to_elicit        = optional(string)
          suppress_next_message = optional(bool)
        }))
        intent = optional(object({
          name = optional(string)
          slot = optional(map(object({
            shape = optional(string)
            value = optional(object({
              interpreted_value = optional(string)
            }))
          })))
        }))
        session_attributes = optional(map(string))
      }))
      success_response = optional(object({
        message_group = list(object({
          message = object({
            custom_payload = optional(object({
              value = string
            }))
            image_response_card = optional(object({
              title = string
              button = optional(list(object({
                text  = string
                value = string
              })))
              image_url = optional(string)
              subtitle  = optional(string)
            }))
            plain_text_message = optional(object({
              value = string
            }))
            ssml_message = optional(object({
              value = string
            }))
          })
          variation = optional(list(object({
            custom_payload = optional(object({
              value = string
            }))
            image_response_card = optional(object({
              title = string
              button = optional(list(object({
                text  = string
                value = string
              })))
              image_url = optional(string)
              subtitle  = optional(string)
            }))
            plain_text_message = optional(object({
              value = string
            }))
            ssml_message = optional(object({
              value = string
            }))
          })))
        }))
        allow_interrupt = optional(bool)
      }))
      timeout_conditional = optional(object({
        active = bool
        conditional_branch = list(object({
          condition = object({
            expression_string = string
          })
          name = string
          next_step = object({
            dialog_action = optional(object({
              type                  = string
              slot_to_elicit        = optional(string)
              suppress_next_message = optional(bool)
            }))
            intent = optional(object({
              name = optional(string)
              slot = optional(map(object({
                shape = optional(string)
                value = optional(object({
                  interpreted_value = optional(string)
                }))
              })))
            }))
            session_attributes = optional(map(string))
          })
          response = optional(object({
            message_group = list(object({
              message = object({
                custom_payload = optional(object({
                  value = string
                }))
                image_response_card = optional(object({
                  title = string
                  button = optional(list(object({
                    text  = string
                    value = string
                  })))
                  image_url = optional(string)
                  subtitle  = optional(string)
                }))
                plain_text_message = optional(object({
                  value = string
                }))
                ssml_message = optional(object({
                  value = string
                }))
              })
              variation = optional(list(object({
                custom_payload = optional(object({
                  value = string
                }))
                image_response_card = optional(object({
                  title = string
                  button = optional(list(object({
                    text  = string
                    value = string
                  })))
                  image_url = optional(string)
                  subtitle  = optional(string)
                }))
                plain_text_message = optional(object({
                  value = string
                }))
                ssml_message = optional(object({
                  value = string
                }))
              })))
            }))
            allow_interrupt = optional(bool)
          }))
        }))
        default_branch = object({
          next_step = object({
            dialog_action = optional(object({
              type                  = string
              slot_to_elicit        = optional(string)
              suppress_next_message = optional(bool)
            }))
            intent = optional(object({
              name = optional(string)
              slot = optional(map(object({
                shape = optional(string)
                value = optional(object({
                  interpreted_value = optional(string)
                }))
              })))
            }))
            session_attributes = optional(map(string))
          })
          response = optional(object({
            message_group = list(object({
              message = object({
                custom_payload = optional(object({
                  value = string
                }))
                image_response_card = optional(object({
                  title = string
                  button = optional(list(object({
                    text  = string
                    value = string
                  })))
                  image_url = optional(string)
                  subtitle  = optional(string)
                }))
                plain_text_message = optional(object({
                  value = string
                }))
                ssml_message = optional(object({
                  value = string
                }))
              })
              variation = optional(list(object({
                custom_payload = optional(object({
                  value = string
                }))
                image_response_card = optional(object({
                  title = string
                  button = optional(list(object({
                    text  = string
                    value = string
                  })))
                  image_url = optional(string)
                  subtitle  = optional(string)
                }))
                plain_text_message = optional(object({
                  value = string
                }))
                ssml_message = optional(object({
                  value = string
                }))
              })))
            }))
            allow_interrupt = optional(bool)
          }))
        })
      }))
      timeout_next_step = optional(object({
        dialog_action = optional(object({
          type                  = string
          slot_to_elicit        = optional(string)
          suppress_next_message = optional(bool)
        }))
        intent = optional(object({
          name = optional(string)
          slot = optional(map(object({
            shape = optional(string)
            value = optional(object({
              interpreted_value = optional(string)
            }))
          })))
        }))
        session_attributes = optional(map(string))
      }))
      timeout_response = optional(object({
        message_group = list(object({
          message = object({
            custom_payload = optional(object({
              value = string
            }))
            image_response_card = optional(object({
              title = string
              button = optional(list(object({
                text  = string
                value = string
              })))
              image_url = optional(string)
              subtitle  = optional(string)
            }))
            plain_text_message = optional(object({
              value = string
            }))
            ssml_message = optional(object({
              value = string
            }))
          })
          variation = optional(list(object({
            custom_payload = optional(object({
              value = string
            }))
            image_response_card = optional(object({
              title = string
              button = optional(list(object({
                text  = string
                value = string
              })))
              image_url = optional(string)
              subtitle  = optional(string)
            }))
            plain_text_message = optional(object({
              value = string
            }))
            ssml_message = optional(object({
              value = string
            }))
          })))
        }))
        allow_interrupt = optional(bool)
      }))
    }))
  })
  default = null

  validation {
    condition = var.fulfillment_code_hook == null ? true : (
      var.fulfillment_code_hook.fulfillment_updates_specification == null ? true :
      var.fulfillment_code_hook.fulfillment_updates_specification.active == false ? true :
      (var.fulfillment_code_hook.fulfillment_updates_specification.start_response != null &&
        var.fulfillment_code_hook.fulfillment_updates_specification.update_response != null &&
      var.fulfillment_code_hook.fulfillment_updates_specification.timeout_in_seconds != null)
    )
    error_message = "resource_aws_lexv2models_intent, fulfillment_code_hook.fulfillment_updates_specification when active is true requires start_response, update_response, and timeout_in_seconds."
  }
}

variable "initial_response_setting" {
  description = "Configuration block for the response that is sent to the user at the beginning of a conversation, before eliciting slot values."
  type = object({
    code_hook = optional(object({
      active                      = bool
      enable_code_hook_invocation = bool
      post_code_hook_specification = object({
        failure_conditional = optional(object({
          active = bool
          conditional_branch = list(object({
            condition = object({
              expression_string = string
            })
            name = string
            next_step = object({
              dialog_action = optional(object({
                type                  = string
                slot_to_elicit        = optional(string)
                suppress_next_message = optional(bool)
              }))
              intent = optional(object({
                name = optional(string)
                slot = optional(map(object({
                  shape = optional(string)
                  value = optional(object({
                    interpreted_value = optional(string)
                  }))
                })))
              }))
              session_attributes = optional(map(string))
            })
            response = optional(object({
              message_group = list(object({
                message = object({
                  custom_payload = optional(object({
                    value = string
                  }))
                  image_response_card = optional(object({
                    title = string
                    button = optional(list(object({
                      text  = string
                      value = string
                    })))
                    image_url = optional(string)
                    subtitle  = optional(string)
                  }))
                  plain_text_message = optional(object({
                    value = string
                  }))
                  ssml_message = optional(object({
                    value = string
                  }))
                })
                variation = optional(list(object({
                  custom_payload = optional(object({
                    value = string
                  }))
                  image_response_card = optional(object({
                    title = string
                    button = optional(list(object({
                      text  = string
                      value = string
                    })))
                    image_url = optional(string)
                    subtitle  = optional(string)
                  }))
                  plain_text_message = optional(object({
                    value = string
                  }))
                  ssml_message = optional(object({
                    value = string
                  }))
                })))
              }))
              allow_interrupt = optional(bool)
            }))
          }))
          default_branch = object({
            next_step = object({
              dialog_action = optional(object({
                type                  = string
                slot_to_elicit        = optional(string)
                suppress_next_message = optional(bool)
              }))
              intent = optional(object({
                name = optional(string)
                slot = optional(map(object({
                  shape = optional(string)
                  value = optional(object({
                    interpreted_value = optional(string)
                  }))
                })))
              }))
              session_attributes = optional(map(string))
            })
            response = optional(object({
              message_group = list(object({
                message = object({
                  custom_payload = optional(object({
                    value = string
                  }))
                  image_response_card = optional(object({
                    title = string
                    button = optional(list(object({
                      text  = string
                      value = string
                    })))
                    image_url = optional(string)
                    subtitle  = optional(string)
                  }))
                  plain_text_message = optional(object({
                    value = string
                  }))
                  ssml_message = optional(object({
                    value = string
                  }))
                })
                variation = optional(list(object({
                  custom_payload = optional(object({
                    value = string
                  }))
                  image_response_card = optional(object({
                    title = string
                    button = optional(list(object({
                      text  = string
                      value = string
                    })))
                    image_url = optional(string)
                    subtitle  = optional(string)
                  }))
                  plain_text_message = optional(object({
                    value = string
                  }))
                  ssml_message = optional(object({
                    value = string
                  }))
                })))
              }))
              allow_interrupt = optional(bool)
            }))
          })
        }))
        failure_next_step = optional(object({
          dialog_action = optional(object({
            type                  = string
            slot_to_elicit        = optional(string)
            suppress_next_message = optional(bool)
          }))
          intent = optional(object({
            name = optional(string)
            slot = optional(map(object({
              shape = optional(string)
              value = optional(object({
                interpreted_value = optional(string)
              }))
            })))
          }))
          session_attributes = optional(map(string))
        }))
        failure_response = optional(object({
          message_group = list(object({
            message = object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })
            variation = optional(list(object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })))
          }))
          allow_interrupt = optional(bool)
        }))
        success_conditional = optional(object({
          active = bool
          conditional_branch = list(object({
            condition = object({
              expression_string = string
            })
            name = string
            next_step = object({
              dialog_action = optional(object({
                type                  = string
                slot_to_elicit        = optional(string)
                suppress_next_message = optional(bool)
              }))
              intent = optional(object({
                name = optional(string)
                slot = optional(map(object({
                  shape = optional(string)
                  value = optional(object({
                    interpreted_value = optional(string)
                  }))
                })))
              }))
              session_attributes = optional(map(string))
            })
            response = optional(object({
              message_group = list(object({
                message = object({
                  custom_payload = optional(object({
                    value = string
                  }))
                  image_response_card = optional(object({
                    title = string
                    button = optional(list(object({
                      text  = string
                      value = string
                    })))
                    image_url = optional(string)
                    subtitle  = optional(string)
                  }))
                  plain_text_message = optional(object({
                    value = string
                  }))
                  ssml_message = optional(object({
                    value = string
                  }))
                })
                variation = optional(list(object({
                  custom_payload = optional(object({
                    value = string
                  }))
                  image_response_card = optional(object({
                    title = string
                    button = optional(list(object({
                      text  = string
                      value = string
                    })))
                    image_url = optional(string)
                    subtitle  = optional(string)
                  }))
                  plain_text_message = optional(object({
                    value = string
                  }))
                  ssml_message = optional(object({
                    value = string
                  }))
                })))
              }))
              allow_interrupt = optional(bool)
            }))
          }))
          default_branch = object({
            next_step = object({
              dialog_action = optional(object({
                type                  = string
                slot_to_elicit        = optional(string)
                suppress_next_message = optional(bool)
              }))
              intent = optional(object({
                name = optional(string)
                slot = optional(map(object({
                  shape = optional(string)
                  value = optional(object({
                    interpreted_value = optional(string)
                  }))
                })))
              }))
              session_attributes = optional(map(string))
            })
            response = optional(object({
              message_group = list(object({
                message = object({
                  custom_payload = optional(object({
                    value = string
                  }))
                  image_response_card = optional(object({
                    title = string
                    button = optional(list(object({
                      text  = string
                      value = string
                    })))
                    image_url = optional(string)
                    subtitle  = optional(string)
                  }))
                  plain_text_message = optional(object({
                    value = string
                  }))
                  ssml_message = optional(object({
                    value = string
                  }))
                })
                variation = optional(list(object({
                  custom_payload = optional(object({
                    value = string
                  }))
                  image_response_card = optional(object({
                    title = string
                    button = optional(list(object({
                      text  = string
                      value = string
                    })))
                    image_url = optional(string)
                    subtitle  = optional(string)
                  }))
                  plain_text_message = optional(object({
                    value = string
                  }))
                  ssml_message = optional(object({
                    value = string
                  }))
                })))
              }))
              allow_interrupt = optional(bool)
            }))
          })
        }))
        success_next_step = optional(object({
          dialog_action = optional(object({
            type                  = string
            slot_to_elicit        = optional(string)
            suppress_next_message = optional(bool)
          }))
          intent = optional(object({
            name = optional(string)
            slot = optional(map(object({
              shape = optional(string)
              value = optional(object({
                interpreted_value = optional(string)
              }))
            })))
          }))
          session_attributes = optional(map(string))
        }))
        success_response = optional(object({
          message_group = list(object({
            message = object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })
            variation = optional(list(object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })))
          }))
          allow_interrupt = optional(bool)
        }))
        timeout_conditional = optional(object({
          active = bool
          conditional_branch = list(object({
            condition = object({
              expression_string = string
            })
            name = string
            next_step = object({
              dialog_action = optional(object({
                type                  = string
                slot_to_elicit        = optional(string)
                suppress_next_message = optional(bool)
              }))
              intent = optional(object({
                name = optional(string)
                slot = optional(map(object({
                  shape = optional(string)
                  value = optional(object({
                    interpreted_value = optional(string)
                  }))
                })))
              }))
              session_attributes = optional(map(string))
            })
            response = optional(object({
              message_group = list(object({
                message = object({
                  custom_payload = optional(object({
                    value = string
                  }))
                  image_response_card = optional(object({
                    title = string
                    button = optional(list(object({
                      text  = string
                      value = string
                    })))
                    image_url = optional(string)
                    subtitle  = optional(string)
                  }))
                  plain_text_message = optional(object({
                    value = string
                  }))
                  ssml_message = optional(object({
                    value = string
                  }))
                })
                variation = optional(list(object({
                  custom_payload = optional(object({
                    value = string
                  }))
                  image_response_card = optional(object({
                    title = string
                    button = optional(list(object({
                      text  = string
                      value = string
                    })))
                    image_url = optional(string)
                    subtitle  = optional(string)
                  }))
                  plain_text_message = optional(object({
                    value = string
                  }))
                  ssml_message = optional(object({
                    value = string
                  }))
                })))
              }))
              allow_interrupt = optional(bool)
            }))
          }))
          default_branch = object({
            next_step = object({
              dialog_action = optional(object({
                type                  = string
                slot_to_elicit        = optional(string)
                suppress_next_message = optional(bool)
              }))
              intent = optional(object({
                name = optional(string)
                slot = optional(map(object({
                  shape = optional(string)
                  value = optional(object({
                    interpreted_value = optional(string)
                  }))
                })))
              }))
              session_attributes = optional(map(string))
            })
            response = optional(object({
              message_group = list(object({
                message = object({
                  custom_payload = optional(object({
                    value = string
                  }))
                  image_response_card = optional(object({
                    title = string
                    button = optional(list(object({
                      text  = string
                      value = string
                    })))
                    image_url = optional(string)
                    subtitle  = optional(string)
                  }))
                  plain_text_message = optional(object({
                    value = string
                  }))
                  ssml_message = optional(object({
                    value = string
                  }))
                })
                variation = optional(list(object({
                  custom_payload = optional(object({
                    value = string
                  }))
                  image_response_card = optional(object({
                    title = string
                    button = optional(list(object({
                      text  = string
                      value = string
                    })))
                    image_url = optional(string)
                    subtitle  = optional(string)
                  }))
                  plain_text_message = optional(object({
                    value = string
                  }))
                  ssml_message = optional(object({
                    value = string
                  }))
                })))
              }))
              allow_interrupt = optional(bool)
            }))
          })
        }))
        timeout_next_step = optional(object({
          dialog_action = optional(object({
            type                  = string
            slot_to_elicit        = optional(string)
            suppress_next_message = optional(bool)
          }))
          intent = optional(object({
            name = optional(string)
            slot = optional(map(object({
              shape = optional(string)
              value = optional(object({
                interpreted_value = optional(string)
              }))
            })))
          }))
          session_attributes = optional(map(string))
        }))
        timeout_response = optional(object({
          message_group = list(object({
            message = object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })
            variation = optional(list(object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })))
          }))
          allow_interrupt = optional(bool)
        }))
      })
      invocation_label = optional(string)
    }))
    conditional = optional(object({
      active = bool
      conditional_branch = list(object({
        condition = object({
          expression_string = string
        })
        name = string
        next_step = object({
          dialog_action = optional(object({
            type                  = string
            slot_to_elicit        = optional(string)
            suppress_next_message = optional(bool)
          }))
          intent = optional(object({
            name = optional(string)
            slot = optional(map(object({
              shape = optional(string)
              value = optional(object({
                interpreted_value = optional(string)
              }))
            })))
          }))
          session_attributes = optional(map(string))
        })
        response = optional(object({
          message_group = list(object({
            message = object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })
            variation = optional(list(object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })))
          }))
          allow_interrupt = optional(bool)
        }))
      }))
      default_branch = object({
        next_step = object({
          dialog_action = optional(object({
            type                  = string
            slot_to_elicit        = optional(string)
            suppress_next_message = optional(bool)
          }))
          intent = optional(object({
            name = optional(string)
            slot = optional(map(object({
              shape = optional(string)
              value = optional(object({
                interpreted_value = optional(string)
              }))
            })))
          }))
          session_attributes = optional(map(string))
        })
        response = optional(object({
          message_group = list(object({
            message = object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })
            variation = optional(list(object({
              custom_payload = optional(object({
                value = string
              }))
              image_response_card = optional(object({
                title = string
                button = optional(list(object({
                  text  = string
                  value = string
                })))
                image_url = optional(string)
                subtitle  = optional(string)
              }))
              plain_text_message = optional(object({
                value = string
              }))
              ssml_message = optional(object({
                value = string
              }))
            })))
          }))
          allow_interrupt = optional(bool)
        }))
      })
    }))
    initial_response = optional(object({
      message_group = list(object({
        message = object({
          custom_payload = optional(object({
            value = string
          }))
          image_response_card = optional(object({
            title = string
            button = optional(list(object({
              text  = string
              value = string
            })))
            image_url = optional(string)
            subtitle  = optional(string)
          }))
          plain_text_message = optional(object({
            value = string
          }))
          ssml_message = optional(object({
            value = string
          }))
        })
        variation = optional(list(object({
          custom_payload = optional(object({
            value = string
          }))
          image_response_card = optional(object({
            title = string
            button = optional(list(object({
              text  = string
              value = string
            })))
            image_url = optional(string)
            subtitle  = optional(string)
          }))
          plain_text_message = optional(object({
            value = string
          }))
          ssml_message = optional(object({
            value = string
          }))
        })))
      }))
      allow_interrupt = optional(bool)
    }))
    next_step = optional(object({
      dialog_action = optional(object({
        type                  = string
        slot_to_elicit        = optional(string)
        suppress_next_message = optional(bool)
      }))
      intent = optional(object({
        name = optional(string)
        slot = optional(map(object({
          shape = optional(string)
          value = optional(object({
            interpreted_value = optional(string)
          }))
        })))
      }))
      session_attributes = optional(map(string))
    }))
  })
  default = null
}

variable "input_context" {
  description = "Configuration blocks for contexts that must be active for this intent to be considered by Amazon Lex."
  type = list(object({
    name = string
  }))
  default = []
}

variable "kendra_configuration" {
  description = "Configuration block for information required to use the AMAZON.KendraSearchIntent intent to connect to an Amazon Kendra index."
  type = object({
    kendra_index                = string
    query_filter_string         = optional(string)
    query_filter_string_enabled = optional(bool)
  })
  default = null

  validation {
    condition     = var.kendra_configuration == null ? true : can(regex("^arn:", var.kendra_configuration.kendra_index))
    error_message = "resource_aws_lexv2models_intent, kendra_configuration.kendra_index must be a valid ARN."
  }
}

variable "output_context" {
  description = "Configuration blocks for contexts that the intent activates when it is fulfilled."
  type = list(object({
    name                    = string
    time_to_live_in_seconds = number
    turns_to_live           = number
  }))
  default = []

  validation {
    condition = alltrue([
      for ctx in var.output_context :
      ctx.time_to_live_in_seconds >= 0 && ctx.turns_to_live >= 0
    ])
    error_message = "resource_aws_lexv2models_intent, output_context.time_to_live_in_seconds and output_context.turns_to_live must be non-negative integers."
  }

  validation {
    condition     = length(var.output_context) <= 10
    error_message = "resource_aws_lexv2models_intent, output_context can have at most 10 contexts."
  }
}

variable "parent_intent_signature" {
  description = "Identifier for the built-in intent to base this intent on."
  type        = string
  default     = null
}

variable "sample_utterance" {
  description = "Configuration block for strings that a user might say to signal the intent."
  type = list(object({
    utterance = string
  }))
  default = []

  validation {
    condition = alltrue([
      for utterance in var.sample_utterance :
      length(utterance.utterance) > 0
    ])
    error_message = "resource_aws_lexv2models_intent, sample_utterance.utterance must be a non-empty string."
  }
}

variable "slot_priority" {
  description = "Configuration block for a new list of slots and their priorities that are contained by the intent."
  type = list(object({
    priority = number
    slot_id  = string
  }))
  default = []

  validation {
    condition = alltrue([
      for slot in var.slot_priority :
      slot.priority >= 0
    ])
    error_message = "resource_aws_lexv2models_intent, slot_priority.priority must be a non-negative integer."
  }
}