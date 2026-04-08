variable "dashboard_id" {
  description = "Identifier for the dashboard."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.dashboard_id))
    error_message = "resource_aws_quicksight_dashboard, dashboard_id must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "name" {
  description = "Display name for the dashboard."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 2048
    error_message = "resource_aws_quicksight_dashboard, name must be between 1 and 2048 characters."
  }
}

variable "version_description" {
  description = "A description of the current dashboard version being created/updated."
  type        = string

  validation {
    condition     = length(var.version_description) > 0 && length(var.version_description) <= 512
    error_message = "resource_aws_quicksight_dashboard, version_description must be between 1 and 512 characters."
  }
}

variable "aws_account_id" {
  description = "AWS account ID. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null

  validation {
    condition     = var.aws_account_id == null || can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "resource_aws_quicksight_dashboard, aws_account_id must be a 12-digit number when provided."
  }
}

variable "dashboard_publish_options" {
  description = "Options for publishing the dashboard."
  type = object({
    ad_hoc_filtering_option = optional(object({
      availability_status = optional(string)
    }))
    data_point_drill_up_down_option = optional(object({
      availability_status = optional(string)
    }))
    data_point_menu_label_option = optional(object({
      availability_status = optional(string)
    }))
    data_point_tooltip_option = optional(object({
      availability_status = optional(string)
    }))
    export_to_csv_option = optional(object({
      availability_status = optional(string)
    }))
    export_with_hidden_fields_option = optional(object({
      availability_status = optional(string)
    }))
    sheet_controls_option = optional(object({
      visibility_state = optional(string)
    }))
    sheet_layout_element_maximization_option = optional(object({
      availability_status = optional(string)
    }))
    visual_axis_sort_option = optional(object({
      availability_status = optional(string)
    }))
    visual_menu_option = optional(object({
      availability_status = optional(string)
    }))
  })
  default = null

  validation {
    condition = var.dashboard_publish_options == null || (
      var.dashboard_publish_options.ad_hoc_filtering_option == null ||
      var.dashboard_publish_options.ad_hoc_filtering_option.availability_status == null ||
      contains(["ENABLED", "DISABLED"], var.dashboard_publish_options.ad_hoc_filtering_option.availability_status)
    )
    error_message = "resource_aws_quicksight_dashboard, dashboard_publish_options.ad_hoc_filtering_option.availability_status must be ENABLED or DISABLED."
  }

  validation {
    condition = var.dashboard_publish_options == null || (
      var.dashboard_publish_options.data_point_drill_up_down_option == null ||
      var.dashboard_publish_options.data_point_drill_up_down_option.availability_status == null ||
      contains(["ENABLED", "DISABLED"], var.dashboard_publish_options.data_point_drill_up_down_option.availability_status)
    )
    error_message = "resource_aws_quicksight_dashboard, dashboard_publish_options.data_point_drill_up_down_option.availability_status must be ENABLED or DISABLED."
  }

  validation {
    condition = var.dashboard_publish_options == null || (
      var.dashboard_publish_options.data_point_menu_label_option == null ||
      var.dashboard_publish_options.data_point_menu_label_option.availability_status == null ||
      contains(["ENABLED", "DISABLED"], var.dashboard_publish_options.data_point_menu_label_option.availability_status)
    )
    error_message = "resource_aws_quicksight_dashboard, dashboard_publish_options.data_point_menu_label_option.availability_status must be ENABLED or DISABLED."
  }

  validation {
    condition = var.dashboard_publish_options == null || (
      var.dashboard_publish_options.data_point_tooltip_option == null ||
      var.dashboard_publish_options.data_point_tooltip_option.availability_status == null ||
      contains(["ENABLED", "DISABLED"], var.dashboard_publish_options.data_point_tooltip_option.availability_status)
    )
    error_message = "resource_aws_quicksight_dashboard, dashboard_publish_options.data_point_tooltip_option.availability_status must be ENABLED or DISABLED."
  }

  validation {
    condition = var.dashboard_publish_options == null || (
      var.dashboard_publish_options.export_to_csv_option == null ||
      var.dashboard_publish_options.export_to_csv_option.availability_status == null ||
      contains(["ENABLED", "DISABLED"], var.dashboard_publish_options.export_to_csv_option.availability_status)
    )
    error_message = "resource_aws_quicksight_dashboard, dashboard_publish_options.export_to_csv_option.availability_status must be ENABLED or DISABLED."
  }

  validation {
    condition = var.dashboard_publish_options == null || (
      var.dashboard_publish_options.export_with_hidden_fields_option == null ||
      var.dashboard_publish_options.export_with_hidden_fields_option.availability_status == null ||
      contains(["ENABLED", "DISABLED"], var.dashboard_publish_options.export_with_hidden_fields_option.availability_status)
    )
    error_message = "resource_aws_quicksight_dashboard, dashboard_publish_options.export_with_hidden_fields_option.availability_status must be ENABLED or DISABLED."
  }

  validation {
    condition = var.dashboard_publish_options == null || (
      var.dashboard_publish_options.sheet_controls_option == null ||
      var.dashboard_publish_options.sheet_controls_option.visibility_state == null ||
      contains(["EXPANDED", "COLLAPSED"], var.dashboard_publish_options.sheet_controls_option.visibility_state)
    )
    error_message = "resource_aws_quicksight_dashboard, dashboard_publish_options.sheet_controls_option.visibility_state must be EXPANDED or COLLAPSED."
  }

  validation {
    condition = var.dashboard_publish_options == null || (
      var.dashboard_publish_options.sheet_layout_element_maximization_option == null ||
      var.dashboard_publish_options.sheet_layout_element_maximization_option.availability_status == null ||
      contains(["ENABLED", "DISABLED"], var.dashboard_publish_options.sheet_layout_element_maximization_option.availability_status)
    )
    error_message = "resource_aws_quicksight_dashboard, dashboard_publish_options.sheet_layout_element_maximization_option.availability_status must be ENABLED or DISABLED."
  }

  validation {
    condition = var.dashboard_publish_options == null || (
      var.dashboard_publish_options.visual_axis_sort_option == null ||
      var.dashboard_publish_options.visual_axis_sort_option.availability_status == null ||
      contains(["ENABLED", "DISABLED"], var.dashboard_publish_options.visual_axis_sort_option.availability_status)
    )
    error_message = "resource_aws_quicksight_dashboard, dashboard_publish_options.visual_axis_sort_option.availability_status must be ENABLED or DISABLED."
  }

  validation {
    condition = var.dashboard_publish_options == null || (
      var.dashboard_publish_options.visual_menu_option == null ||
      var.dashboard_publish_options.visual_menu_option.availability_status == null ||
      contains(["ENABLED", "DISABLED"], var.dashboard_publish_options.visual_menu_option.availability_status)
    )
    error_message = "resource_aws_quicksight_dashboard, dashboard_publish_options.visual_menu_option.availability_status must be ENABLED or DISABLED."
  }
}

variable "definition" {
  description = "A detailed dashboard definition. Only one of definition or source_entity should be configured."
  type = object({
    data_set_identifiers_declarations = list(object({
      data_set_arn = string
      identifier   = string
    }))
    analysis_defaults = optional(object({
      default_new_sheet_configuration = object({
        interactive_layout_configuration = optional(object({
          grid = optional(object({
            canvas_size_options = object({
              screen_canvas_size_options = optional(object({
                optimized_view_port_width = string
                resize_option             = string
              }))
            })
          }))
          free_form = optional(object({
            canvas_size_options = object({
              screen_canvas_size_options = optional(object({
                optimized_view_port_width = string
                resize_option             = string
              }))
            })
          }))
        }))
        paginated_layout_configuration = optional(object({
          section_based = optional(object({
            canvas_size_options = object({
              paper_canvas_size_options = optional(object({
                paper_margin = optional(object({
                  bottom = optional(string)
                  left   = optional(string)
                  right  = optional(string)
                  top    = optional(string)
                }))
                paper_orientation = optional(string)
                paper_size        = optional(string)
              }))
            })
          }))
        }))
        sheet_content_type = optional(string)
      })
    }))
    calculated_fields = optional(list(object({
      data_set_identifier = string
      expression          = string
      name                = string
    })))
    column_configurations = optional(list(object({
      column = object({
        column_name         = string
        data_set_identifier = string
      })
      format_configuration = optional(object({
        date_time_format_configuration = optional(object({
          date_time_format = optional(string)
          null_value_format_configuration = optional(object({
            null_string = string
          }))
          numeric_format_configuration = optional(object({
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
          }))
        }))
        number_format_configuration = optional(object({
          format_configuration = optional(object({
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
          }))
        }))
        string_format_configuration = optional(object({
          null_value_format_configuration = optional(object({
            null_string = string
          }))
          numeric_format_configuration = optional(object({
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
      })
      status = optional(string)
    })))
    parameters_declarations = optional(list(object({
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
        mapped_data_set_parameters = optional(list(object({
          data_set_identifier     = string
          data_set_parameter_name = string
        })))
        parameter_value_type = string
        time_granularity     = optional(string)
        values_when_unset = optional(object({
          custom_value            = optional(string)
          value_when_unset_option = optional(string)
        }))
      }))
      decimal_parameter_declaration = optional(object({
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
          static_values = optional(list(number))
        }))
        mapped_data_set_parameters = optional(list(object({
          data_set_identifier     = string
          data_set_parameter_name = string
        })))
        parameter_value_type = string
        values_when_unset = optional(object({
          custom_value            = optional(number)
          value_when_unset_option = optional(string)
        }))
      }))
      integer_parameter_declaration = optional(object({
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
          static_values = optional(list(number))
        }))
        mapped_data_set_parameters = optional(list(object({
          data_set_identifier     = string
          data_set_parameter_name = string
        })))
        parameter_value_type = string
        values_when_unset = optional(object({
          custom_value            = optional(number)
          value_when_unset_option = optional(string)
        }))
      }))
      string_parameter_declaration = optional(object({
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
          static_values = optional(list(string))
        }))
        mapped_data_set_parameters = optional(list(object({
          data_set_identifier     = string
          data_set_parameter_name = string
        })))
        parameter_value_type = string
        values_when_unset = optional(object({
          custom_value            = optional(string)
          value_when_unset_option = optional(string)
        }))
      }))
    })))
    sheets = optional(list(any))
  })
  default = null

  validation {
    condition = var.definition == null || (
      length(var.definition.data_set_identifiers_declarations) > 0
    )
    error_message = "resource_aws_quicksight_dashboard, definition.data_set_identifiers_declarations must contain at least one item when definition is provided."
  }
}

variable "parameters" {
  description = "The parameters for the creation of the dashboard, which you want to use to override the default settings."
  type = object({
    date_time_parameters = optional(list(object({
      name   = string
      values = list(string)
    })))
    decimal_parameters = optional(list(object({
      name   = string
      values = list(number)
    })))
    integer_parameters = optional(list(object({
      name   = string
      values = list(number)
    })))
    string_parameters = optional(list(object({
      name   = string
      values = list(string)
    })))
  })
  default = null
}

variable "permissions" {
  description = "A set of resource permissions on the dashboard. Maximum of 64 items."
  type = list(object({
    actions   = list(string)
    principal = string
  }))
  default = null

  validation {
    condition     = var.permissions == null || length(var.permissions) <= 64
    error_message = "resource_aws_quicksight_dashboard, permissions cannot contain more than 64 items."
  }

  validation {
    condition = var.permissions == null || alltrue([
      for permission in var.permissions : length(permission.actions) > 0
    ])
    error_message = "resource_aws_quicksight_dashboard, permissions.actions must contain at least one action for each permission."
  }

  validation {
    condition = var.permissions == null || alltrue([
      for permission in var.permissions : can(regex("^arn:aws", permission.principal))
    ])
    error_message = "resource_aws_quicksight_dashboard, permissions.principal must be a valid ARN starting with 'arn:aws'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_quicksight_dashboard, region must be a valid AWS region identifier when provided."
  }
}

variable "source_entity" {
  description = "The entity that you are using as a source when you create the dashboard (template). Only one of definition or source_entity should be configured."
  type = object({
    source_template = optional(object({
      arn = string
      data_set_references = list(object({
        data_set_arn         = string
        data_set_placeholder = string
      }))
    }))
  })
  default = null

  validation {
    condition = var.source_entity == null || (
      var.source_entity.source_template != null &&
      can(regex("^arn:aws", var.source_entity.source_template.arn))
    )
    error_message = "resource_aws_quicksight_dashboard, source_entity.source_template.arn must be a valid ARN starting with 'arn:aws' when source_entity is provided."
  }

  validation {
    condition = var.source_entity == null || (
      var.source_entity.source_template != null &&
      length(var.source_entity.source_template.data_set_references) > 0
    )
    error_message = "resource_aws_quicksight_dashboard, source_entity.source_template.data_set_references must contain at least one item when source_entity is provided."
  }

  validation {
    condition = var.source_entity == null || (
      var.source_entity.source_template == null ||
      alltrue([
        for ref in var.source_entity.source_template.data_set_references : can(regex("^arn:aws", ref.data_set_arn))
      ])
    )
    error_message = "resource_aws_quicksight_dashboard, source_entity.source_template.data_set_references.data_set_arn must be valid ARNs starting with 'arn:aws'."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = null
}

variable "theme_arn" {
  description = "The Amazon Resource Name (ARN) of the theme that is being used for this dashboard. The theme ARN must exist in the same AWS account where you create the dashboard."
  type        = string
  default     = null

  validation {
    condition     = var.theme_arn == null || can(regex("^arn:aws", var.theme_arn))
    error_message = "resource_aws_quicksight_dashboard, theme_arn must be a valid ARN starting with 'arn:aws' when provided."
  }
}