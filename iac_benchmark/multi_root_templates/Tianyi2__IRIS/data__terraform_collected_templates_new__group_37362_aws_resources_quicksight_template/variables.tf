variable "template_id" {
  description = "Identifier for the template."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9_.-]*$", var.template_id))
    error_message = "resource_aws_quicksight_template, template_id must be a valid identifier containing only alphanumeric characters, underscores, periods, and hyphens, and must start with an alphanumeric character."
  }
}

variable "name" {
  description = "Display name for the template."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 2048
    error_message = "resource_aws_quicksight_template, name must be between 1 and 2048 characters long."
  }
}

variable "version_description" {
  description = "A description of the current template version being created/updated."
  type        = string

  validation {
    condition     = length(var.version_description) >= 1 && length(var.version_description) <= 512
    error_message = "resource_aws_quicksight_template, version_description must be between 1 and 512 characters long."
  }
}

variable "aws_account_id" {
  description = "AWS account ID. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null

  validation {
    condition     = var.aws_account_id == null || can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "resource_aws_quicksight_template, aws_account_id must be a valid 12-digit AWS account ID."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_quicksight_template, region must be a valid AWS region identifier."
  }
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{1,128}$", k)) && can(regex("^.{0,256}$", v))
    ])
    error_message = "resource_aws_quicksight_template, tags keys must be 1-128 characters and values must be 0-256 characters."
  }
}

variable "definition" {
  description = "A detailed template definition. Only one of definition or source_entity should be configured."
  type = object({
    data_set_configuration = list(object({
      data_set_schema = optional(object({
        column_schema_list = optional(list(object({
          name            = string
          data_type       = string
          geographic_role = optional(string)
        })))
      }))
      placeholder = optional(string)
    }))
    analysis_defaults = optional(object({
      default_new_sheet_configuration = object({
        interactive_layout_configuration = optional(object({
          grid = optional(object({
            can_size_to_fit_width = optional(bool)
          }))
          free_form = optional(object({
            can_size_to_fit_width = optional(bool)
          }))
        }))
        paginated_layout_configuration = optional(object({
          section_based = optional(object({
            can_size_to_fit_width = optional(bool)
          }))
        }))
        sheet_content_type = optional(string)
      })
    }))
    calculated_fields = optional(list(object({
      name                = string
      data_set_identifier = string
      expression          = string
    })))
    column_configurations = optional(list(object({
      column = object({
        column_name         = string
        data_set_identifier = string
      })
      format_configuration = optional(object({
        string_format_configuration = optional(object({
          null_value_format_configuration = optional(object({
            null_string = string
          }))
          numeric_format_configuration = optional(object({
            format_configuration = object({
              number_display_format_configuration = optional(object({
                decimal_places_configuration = optional(object({
                  decimal_places = number
                }))
                negative_value_configuration = optional(object({
                  display_mode = string
                }))
                null_value_format_configuration = optional(object({
                  null_string = string
                }))
                number_scale = optional(string)
                prefix       = optional(string)
                separator_configuration = optional(object({
                  decimal_separator = optional(string)
                  thousands_separator = optional(object({
                    symbol     = optional(string)
                    visibility = optional(string)
                  }))
                }))
                suffix = optional(string)
              }))
              currency_display_format_configuration = optional(object({
                decimal_places_configuration = optional(object({
                  decimal_places = number
                }))
                negative_value_configuration = optional(object({
                  display_mode = string
                }))
                null_value_format_configuration = optional(object({
                  null_string = string
                }))
                number_scale = optional(string)
                prefix       = optional(string)
                separator_configuration = optional(object({
                  decimal_separator = optional(string)
                  thousands_separator = optional(object({
                    symbol     = optional(string)
                    visibility = optional(string)
                  }))
                }))
                suffix = optional(string)
                symbol = optional(string)
              }))
              percentage_display_format_configuration = optional(object({
                decimal_places_configuration = optional(object({
                  decimal_places = number
                }))
                negative_value_configuration = optional(object({
                  display_mode = string
                }))
                null_value_format_configuration = optional(object({
                  null_string = string
                }))
                prefix = optional(string)
                separator_configuration = optional(object({
                  decimal_separator = optional(string)
                  thousands_separator = optional(object({
                    symbol     = optional(string)
                    visibility = optional(string)
                  }))
                }))
                suffix = optional(string)
              }))
            })
          }))
        }))
        number_format_configuration = optional(object({
          format_configuration = object({
            number_display_format_configuration = optional(object({
              decimal_places_configuration = optional(object({
                decimal_places = number
              }))
              negative_value_configuration = optional(object({
                display_mode = string
              }))
              null_value_format_configuration = optional(object({
                null_string = string
              }))
              number_scale = optional(string)
              prefix       = optional(string)
              separator_configuration = optional(object({
                decimal_separator = optional(string)
                thousands_separator = optional(object({
                  symbol     = optional(string)
                  visibility = optional(string)
                }))
              }))
              suffix = optional(string)
            }))
            currency_display_format_configuration = optional(object({
              decimal_places_configuration = optional(object({
                decimal_places = number
              }))
              negative_value_configuration = optional(object({
                display_mode = string
              }))
              null_value_format_configuration = optional(object({
                null_string = string
              }))
              number_scale = optional(string)
              prefix       = optional(string)
              separator_configuration = optional(object({
                decimal_separator = optional(string)
                thousands_separator = optional(object({
                  symbol     = optional(string)
                  visibility = optional(string)
                }))
              }))
              suffix = optional(string)
              symbol = optional(string)
            }))
            percentage_display_format_configuration = optional(object({
              decimal_places_configuration = optional(object({
                decimal_places = number
              }))
              negative_value_configuration = optional(object({
                display_mode = string
              }))
              null_value_format_configuration = optional(object({
                null_string = string
              }))
              prefix = optional(string)
              separator_configuration = optional(object({
                decimal_separator = optional(string)
                thousands_separator = optional(object({
                  symbol     = optional(string)
                  visibility = optional(string)
                }))
              }))
              suffix = optional(string)
            }))
          })
        }))
        date_time_format_configuration = optional(object({
          date_time_format = optional(string)
          null_value_format_configuration = optional(object({
            null_string = string
          }))
          numeric_format_configuration = optional(object({
            format_configuration = object({
              number_display_format_configuration = optional(object({
                decimal_places_configuration = optional(object({
                  decimal_places = number
                }))
                negative_value_configuration = optional(object({
                  display_mode = string
                }))
                null_value_format_configuration = optional(object({
                  null_string = string
                }))
                number_scale = optional(string)
                prefix       = optional(string)
                separator_configuration = optional(object({
                  decimal_separator = optional(string)
                  thousands_separator = optional(object({
                    symbol     = optional(string)
                    visibility = optional(string)
                  }))
                }))
                suffix = optional(string)
              }))
            })
          }))
        }))
      }))
      role = optional(string)
    })))
    filter_groups = optional(list(object({
      cross_dataset   = string
      filter_group_id = string
      filters         = list(any)
      scope_configuration = object({
        selected_sheets = optional(object({
          sheet_visual_scoping_configurations = optional(list(object({
            sheet_id   = string
            scope      = string
            visual_ids = optional(list(string))
          })))
        }))
        all_sheets = optional(object({}))
      })
      status = string
    })))
    parameters_declarations = optional(list(object({
      name = string
      date_time_parameter_declaration = optional(object({
        name = string
        default_values = optional(object({
          dynamic_value = optional(object({
            default_value_column = object({
              column_name         = string
              data_set_identifier = string
            })
            group_name_column = optional(object({
              column_name         = string
              data_set_identifier = string
            }))
            user_name_column = optional(object({
              column_name         = string
              data_set_identifier = string
            }))
          }))
          rolling_date = optional(object({
            data_set_identifier = optional(string)
            expression          = string
          }))
          static_values = optional(list(string))
        }))
        time_granularity = optional(string)
        value_when_unset = optional(object({
          custom_value            = optional(string)
          value_when_unset_option = optional(string)
        }))
      }))
      decimal_parameter_declaration = optional(object({
        name                 = string
        parameter_value_type = string
        default_values = optional(object({
          dynamic_value = optional(object({
            default_value_column = object({
              column_name         = string
              data_set_identifier = string
            })
            group_name_column = optional(object({
              column_name         = string
              data_set_identifier = string
            }))
            user_name_column = optional(object({
              column_name         = string
              data_set_identifier = string
            }))
          }))
          static_values = optional(list(number))
        }))
        value_when_unset = optional(object({
          custom_value            = optional(number)
          value_when_unset_option = optional(string)
        }))
      }))
      integer_parameter_declaration = optional(object({
        name                 = string
        parameter_value_type = string
        default_values = optional(object({
          dynamic_value = optional(object({
            default_value_column = object({
              column_name         = string
              data_set_identifier = string
            })
            group_name_column = optional(object({
              column_name         = string
              data_set_identifier = string
            }))
            user_name_column = optional(object({
              column_name         = string
              data_set_identifier = string
            }))
          }))
          static_values = optional(list(number))
        }))
        value_when_unset = optional(object({
          custom_value            = optional(number)
          value_when_unset_option = optional(string)
        }))
      }))
      string_parameter_declaration = optional(object({
        name                 = string
        parameter_value_type = string
        default_values = optional(object({
          dynamic_value = optional(object({
            default_value_column = object({
              column_name         = string
              data_set_identifier = string
            })
            group_name_column = optional(object({
              column_name         = string
              data_set_identifier = string
            }))
            user_name_column = optional(object({
              column_name         = string
              data_set_identifier = string
            }))
          }))
          static_values = optional(list(string))
        }))
        value_when_unset = optional(object({
          custom_value            = optional(string)
          value_when_unset_option = optional(string)
        }))
      }))
    })))
    sheets = optional(list(object({
      description           = optional(string)
      filter_controls       = optional(list(any))
      layouts               = optional(list(any))
      name                  = optional(string)
      parameter_controls    = optional(list(any))
      sheet_control_layouts = optional(list(any))
      sheet_id              = string
      text_boxes            = optional(list(any))
      title                 = optional(string)
      visuals               = optional(list(any))
    })))
  })
  default = null

  validation {
    condition     = var.definition == null || var.source_entity == null
    error_message = "resource_aws_quicksight_template, definition - only one of definition or source_entity should be configured."
  }
}

variable "permissions" {
  description = "A set of resource permissions on the template. Maximum of 64 items."
  type = list(object({
    actions   = list(string)
    principal = string
  }))
  default = null

  validation {
    condition     = var.permissions == null || length(var.permissions) <= 64
    error_message = "resource_aws_quicksight_template, permissions can have a maximum of 64 items."
  }

  validation {
    condition = var.permissions == null || alltrue([
      for perm in var.permissions : can(regex("^arn:aws[a-zA-Z-]*:quicksight:[a-z0-9-]*:[0-9]{12}:(user|group)/.*", perm.principal))
    ])
    error_message = "resource_aws_quicksight_template, permissions principal must be a valid QuickSight user or group ARN."
  }

  validation {
    condition = var.permissions == null || alltrue([
      for perm in var.permissions : length(perm.actions) > 0
    ])
    error_message = "resource_aws_quicksight_template, permissions actions list cannot be empty."
  }
}

variable "source_entity" {
  description = "The entity that you are using as a source when you create the template (analysis or template). Only one of definition or source_entity should be configured."
  type = object({
    source_analysis = optional(object({
      arn = string
      data_set_references = list(object({
        data_set_arn         = string
        data_set_placeholder = string
      }))
    }))
    source_template = optional(object({
      arn = string
    }))
  })
  default = null


  validation {
    condition = var.source_entity == null || (
      (var.source_entity.source_analysis != null) != (var.source_entity.source_template != null)
    )
    error_message = "resource_aws_quicksight_template, source_entity - only one of source_analysis or source_template should be configured."
  }

  validation {
    condition     = var.source_entity == null || var.source_entity.source_analysis == null || can(regex("^arn:aws[a-zA-Z-]*:quicksight:[a-z0-9-]*:[0-9]{12}:analysis/.*", var.source_entity.source_analysis.arn))
    error_message = "resource_aws_quicksight_template, source_entity source_analysis arn must be a valid QuickSight analysis ARN."
  }

  validation {
    condition     = var.source_entity == null || var.source_entity.source_template == null || can(regex("^arn:aws[a-zA-Z-]*:quicksight:[a-z0-9-]*:[0-9]{12}:template/.*", var.source_entity.source_template.arn))
    error_message = "resource_aws_quicksight_template, source_entity source_template arn must be a valid QuickSight template ARN."
  }

  validation {
    condition = var.source_entity == null || var.source_entity.source_analysis == null || alltrue([
      for ref in var.source_entity.source_analysis.data_set_references : can(regex("^arn:aws[a-zA-Z-]*:quicksight:[a-z0-9-]*:[0-9]{12}:dataset/.*", ref.data_set_arn))
    ])
    error_message = "resource_aws_quicksight_template, source_entity source_analysis data_set_references data_set_arn must be valid QuickSight dataset ARNs."
  }
}

variable "timeouts" {
  description = "Configuration options for resource operation timeouts."
  type = object({
    create = optional(string, "5m")
    update = optional(string, "5m")
    delete = optional(string, "5m")
  })
  default = {
    create = "5m"
    update = "5m"
    delete = "5m"
  }

  validation {
    condition = alltrue([
      can(regex("^[0-9]+[smh]$", var.timeouts.create)),
      can(regex("^[0-9]+[smh]$", var.timeouts.update)),
      can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    ])
    error_message = "resource_aws_quicksight_template, timeouts values must be valid duration strings (e.g., '5m', '10s', '1h')."
  }
}