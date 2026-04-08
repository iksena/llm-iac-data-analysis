resource "aws_quicksight_dashboard" "this" {
  dashboard_id        = var.dashboard_id
  name                = var.name
  version_description = var.version_description

  aws_account_id = var.aws_account_id

  dynamic "dashboard_publish_options" {
    for_each = var.dashboard_publish_options != null ? [var.dashboard_publish_options] : []
    content {
      dynamic "ad_hoc_filtering_option" {
        for_each = dashboard_publish_options.value.ad_hoc_filtering_option != null ? [dashboard_publish_options.value.ad_hoc_filtering_option] : []
        content {
          availability_status = ad_hoc_filtering_option.value.availability_status
        }
      }

      dynamic "data_point_drill_up_down_option" {
        for_each = dashboard_publish_options.value.data_point_drill_up_down_option != null ? [dashboard_publish_options.value.data_point_drill_up_down_option] : []
        content {
          availability_status = data_point_drill_up_down_option.value.availability_status
        }
      }

      dynamic "data_point_menu_label_option" {
        for_each = dashboard_publish_options.value.data_point_menu_label_option != null ? [dashboard_publish_options.value.data_point_menu_label_option] : []
        content {
          availability_status = data_point_menu_label_option.value.availability_status
        }
      }

      dynamic "data_point_tooltip_option" {
        for_each = dashboard_publish_options.value.data_point_tooltip_option != null ? [dashboard_publish_options.value.data_point_tooltip_option] : []
        content {
          availability_status = data_point_tooltip_option.value.availability_status
        }
      }

      dynamic "export_to_csv_option" {
        for_each = dashboard_publish_options.value.export_to_csv_option != null ? [dashboard_publish_options.value.export_to_csv_option] : []
        content {
          availability_status = export_to_csv_option.value.availability_status
        }
      }

      dynamic "export_with_hidden_fields_option" {
        for_each = dashboard_publish_options.value.export_with_hidden_fields_option != null ? [dashboard_publish_options.value.export_with_hidden_fields_option] : []
        content {
          availability_status = export_with_hidden_fields_option.value.availability_status
        }
      }

      dynamic "sheet_controls_option" {
        for_each = dashboard_publish_options.value.sheet_controls_option != null ? [dashboard_publish_options.value.sheet_controls_option] : []
        content {
          visibility_state = sheet_controls_option.value.visibility_state
        }
      }

      dynamic "sheet_layout_element_maximization_option" {
        for_each = dashboard_publish_options.value.sheet_layout_element_maximization_option != null ? [dashboard_publish_options.value.sheet_layout_element_maximization_option] : []
        content {
          availability_status = sheet_layout_element_maximization_option.value.availability_status
        }
      }

      dynamic "visual_axis_sort_option" {
        for_each = dashboard_publish_options.value.visual_axis_sort_option != null ? [dashboard_publish_options.value.visual_axis_sort_option] : []
        content {
          availability_status = visual_axis_sort_option.value.availability_status
        }
      }

      dynamic "visual_menu_option" {
        for_each = dashboard_publish_options.value.visual_menu_option != null ? [dashboard_publish_options.value.visual_menu_option] : []
        content {
          availability_status = visual_menu_option.value.availability_status
        }
      }
    }
  }

  dynamic "definition" {
    for_each = var.definition != null ? [var.definition] : []
    content {
      dynamic "data_set_identifiers_declarations" {
        for_each = definition.value.data_set_identifiers_declarations
        content {
          data_set_arn = data_set_identifiers_declarations.value.data_set_arn
          identifier   = data_set_identifiers_declarations.value.identifier
        }
      }

      dynamic "analysis_defaults" {
        for_each = definition.value.analysis_defaults != null ? [definition.value.analysis_defaults] : []
        content {
          dynamic "default_new_sheet_configuration" {
            for_each = analysis_defaults.value.default_new_sheet_configuration != null ? [analysis_defaults.value.default_new_sheet_configuration] : []
            content {
              dynamic "interactive_layout_configuration" {
                for_each = default_new_sheet_configuration.value.interactive_layout_configuration != null ? [default_new_sheet_configuration.value.interactive_layout_configuration] : []
                content {
                  dynamic "grid" {
                    for_each = interactive_layout_configuration.value.grid != null ? [interactive_layout_configuration.value.grid] : []
                    content {
                      dynamic "canvas_size_options" {
                        for_each = grid.value.canvas_size_options != null ? [grid.value.canvas_size_options] : []
                        content {
                          dynamic "screen_canvas_size_options" {
                            for_each = canvas_size_options.value.screen_canvas_size_options != null ? [canvas_size_options.value.screen_canvas_size_options] : []
                            content {
                              optimized_view_port_width = screen_canvas_size_options.value.optimized_view_port_width
                              resize_option             = screen_canvas_size_options.value.resize_option != null ? screen_canvas_size_options.value.resize_option : "FIXED"
                            }
                          }
                        }
                      }
                    }
                  }

                  dynamic "free_form" {
                    for_each = interactive_layout_configuration.value.free_form != null ? [interactive_layout_configuration.value.free_form] : []
                    content {
                      dynamic "canvas_size_options" {
                        for_each = free_form.value.canvas_size_options != null ? [free_form.value.canvas_size_options] : []
                        content {
                          dynamic "screen_canvas_size_options" {
                            for_each = canvas_size_options.value.screen_canvas_size_options != null ? [canvas_size_options.value.screen_canvas_size_options] : []
                            content {
                              optimized_view_port_width = screen_canvas_size_options.value.optimized_view_port_width
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }

              dynamic "paginated_layout_configuration" {
                for_each = default_new_sheet_configuration.value.paginated_layout_configuration != null ? [default_new_sheet_configuration.value.paginated_layout_configuration] : []
                content {
                  dynamic "section_based" {
                    for_each = paginated_layout_configuration.value.section_based != null ? [paginated_layout_configuration.value.section_based] : []
                    content {
                      dynamic "canvas_size_options" {
                        for_each = section_based.value.canvas_size_options != null ? [section_based.value.canvas_size_options] : []
                        content {
                          dynamic "paper_canvas_size_options" {
                            for_each = canvas_size_options.value.paper_canvas_size_options != null ? [canvas_size_options.value.paper_canvas_size_options] : []
                            content {
                              dynamic "paper_margin" {
                                for_each = paper_canvas_size_options.value.paper_margin != null ? [paper_canvas_size_options.value.paper_margin] : []
                                content {
                                  bottom = paper_margin.value.bottom
                                  left   = paper_margin.value.left
                                  right  = paper_margin.value.right
                                  top    = paper_margin.value.top
                                }
                              }
                              paper_orientation = paper_canvas_size_options.value.paper_orientation
                              paper_size        = paper_canvas_size_options.value.paper_size
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }

              sheet_content_type = default_new_sheet_configuration.value.sheet_content_type
            }
          }
        }
      }

      dynamic "calculated_fields" {
        for_each = definition.value.calculated_fields != null ? definition.value.calculated_fields : []
        content {
          data_set_identifier = calculated_fields.value.data_set_identifier
          expression          = calculated_fields.value.expression
          name                = calculated_fields.value.name
        }
      }

      dynamic "column_configurations" {
        for_each = definition.value.column_configurations != null ? definition.value.column_configurations : []
        content {
          dynamic "column" {
            for_each = [column_configurations.value.column]
            content {
              column_name         = column.value.column_name
              data_set_identifier = column.value.data_set_identifier
            }
          }

          dynamic "format_configuration" {
            for_each = column_configurations.value.format_configuration != null ? [column_configurations.value.format_configuration] : []
            content {
              dynamic "date_time_format_configuration" {
                for_each = format_configuration.value.date_time_format_configuration != null ? [format_configuration.value.date_time_format_configuration] : []
                content {
                  date_time_format = date_time_format_configuration.value.date_time_format

                  dynamic "null_value_format_configuration" {
                    for_each = date_time_format_configuration.value.null_value_format_configuration != null ? [date_time_format_configuration.value.null_value_format_configuration] : []
                    content {
                      null_string = null_value_format_configuration.value.null_string
                    }
                  }

                  dynamic "numeric_format_configuration" {
                    for_each = date_time_format_configuration.value.numeric_format_configuration != null ? [date_time_format_configuration.value.numeric_format_configuration] : []
                    content {
                      dynamic "currency_display_format_configuration" {
                        for_each = numeric_format_configuration.value.currency_display_format_configuration != null ? [numeric_format_configuration.value.currency_display_format_configuration] : []
                        content {
                          dynamic "decimal_places_configuration" {
                            for_each = currency_display_format_configuration.value.decimal_places_configuration != null ? [currency_display_format_configuration.value.decimal_places_configuration] : []
                            content {
                              decimal_places = decimal_places_configuration.value.decimal_places
                            }
                          }

                          dynamic "negative_value_configuration" {
                            for_each = currency_display_format_configuration.value.negative_value_configuration != null ? [currency_display_format_configuration.value.negative_value_configuration] : []
                            content {
                              display_mode = negative_value_configuration.value.display_mode
                            }
                          }

                          dynamic "null_value_format_configuration" {
                            for_each = currency_display_format_configuration.value.null_value_format_configuration != null ? [currency_display_format_configuration.value.null_value_format_configuration] : []
                            content {
                              null_string = null_value_format_configuration.value.null_string
                            }
                          }

                          number_scale = currency_display_format_configuration.value.number_scale
                          prefix       = currency_display_format_configuration.value.prefix

                          dynamic "separator_configuration" {
                            for_each = currency_display_format_configuration.value.separator_configuration != null ? [currency_display_format_configuration.value.separator_configuration] : []
                            content {
                              decimal_separator = separator_configuration.value.decimal_separator

                              dynamic "thousands_separator" {
                                for_each = separator_configuration.value.thousands_separator != null ? [separator_configuration.value.thousands_separator] : []
                                content {
                                  symbol     = thousands_separator.value.symbol
                                  visibility = thousands_separator.value.visibility
                                }
                              }
                            }
                          }

                          suffix = currency_display_format_configuration.value.suffix
                          symbol = currency_display_format_configuration.value.symbol
                        }
                      }

                      dynamic "number_display_format_configuration" {
                        for_each = numeric_format_configuration.value.number_display_format_configuration != null ? [numeric_format_configuration.value.number_display_format_configuration] : []
                        content {
                          dynamic "decimal_places_configuration" {
                            for_each = number_display_format_configuration.value.decimal_places_configuration != null ? [number_display_format_configuration.value.decimal_places_configuration] : []
                            content {
                              decimal_places = decimal_places_configuration.value.decimal_places
                            }
                          }

                          dynamic "negative_value_configuration" {
                            for_each = number_display_format_configuration.value.negative_value_configuration != null ? [number_display_format_configuration.value.negative_value_configuration] : []
                            content {
                              display_mode = negative_value_configuration.value.display_mode
                            }
                          }

                          dynamic "null_value_format_configuration" {
                            for_each = number_display_format_configuration.value.null_value_format_configuration != null ? [number_display_format_configuration.value.null_value_format_configuration] : []
                            content {
                              null_string = null_value_format_configuration.value.null_string
                            }
                          }

                          number_scale = number_display_format_configuration.value.number_scale
                          prefix       = number_display_format_configuration.value.prefix

                          dynamic "separator_configuration" {
                            for_each = number_display_format_configuration.value.separator_configuration != null ? [number_display_format_configuration.value.separator_configuration] : []
                            content {
                              decimal_separator = separator_configuration.value.decimal_separator

                              dynamic "thousands_separator" {
                                for_each = separator_configuration.value.thousands_separator != null ? [separator_configuration.value.thousands_separator] : []
                                content {
                                  symbol     = thousands_separator.value.symbol
                                  visibility = thousands_separator.value.visibility
                                }
                              }
                            }
                          }

                          suffix = number_display_format_configuration.value.suffix
                        }
                      }

                      dynamic "percentage_display_format_configuration" {
                        for_each = numeric_format_configuration.value.percentage_display_format_configuration != null ? [numeric_format_configuration.value.percentage_display_format_configuration] : []
                        content {
                          dynamic "decimal_places_configuration" {
                            for_each = percentage_display_format_configuration.value.decimal_places_configuration != null ? [percentage_display_format_configuration.value.decimal_places_configuration] : []
                            content {
                              decimal_places = decimal_places_configuration.value.decimal_places
                            }
                          }

                          dynamic "negative_value_configuration" {
                            for_each = percentage_display_format_configuration.value.negative_value_configuration != null ? [percentage_display_format_configuration.value.negative_value_configuration] : []
                            content {
                              display_mode = negative_value_configuration.value.display_mode
                            }
                          }

                          dynamic "null_value_format_configuration" {
                            for_each = percentage_display_format_configuration.value.null_value_format_configuration != null ? [percentage_display_format_configuration.value.null_value_format_configuration] : []
                            content {
                              null_string = null_value_format_configuration.value.null_string
                            }
                          }

                          prefix = percentage_display_format_configuration.value.prefix

                          dynamic "separator_configuration" {
                            for_each = percentage_display_format_configuration.value.separator_configuration != null ? [percentage_display_format_configuration.value.separator_configuration] : []
                            content {
                              decimal_separator = separator_configuration.value.decimal_separator

                              dynamic "thousands_separator" {
                                for_each = separator_configuration.value.thousands_separator != null ? [separator_configuration.value.thousands_separator] : []
                                content {
                                  symbol     = thousands_separator.value.symbol
                                  visibility = thousands_separator.value.visibility
                                }
                              }
                            }
                          }

                          suffix = percentage_display_format_configuration.value.suffix
                        }
                      }
                    }
                  }
                }
              }

              dynamic "number_format_configuration" {
                for_each = format_configuration.value.number_format_configuration != null ? [format_configuration.value.number_format_configuration] : []
                content {
                  # Placeholder for number format configuration
                }
              }

              dynamic "string_format_configuration" {
                for_each = format_configuration.value.string_format_configuration != null ? [format_configuration.value.string_format_configuration] : []
                content {
                  dynamic "null_value_format_configuration" {
                    for_each = string_format_configuration.value.null_value_format_configuration != null ? [string_format_configuration.value.null_value_format_configuration] : []
                    content {
                      null_string = null_value_format_configuration.value.null_string
                    }
                  }

                  dynamic "numeric_format_configuration" {
                    for_each = string_format_configuration.value.numeric_format_configuration != null ? [string_format_configuration.value.numeric_format_configuration] : []
                    content {
                      dynamic "currency_display_format_configuration" {
                        for_each = numeric_format_configuration.value.currency_display_format_configuration != null ? [numeric_format_configuration.value.currency_display_format_configuration] : []
                        content {
                          dynamic "decimal_places_configuration" {
                            for_each = currency_display_format_configuration.value.decimal_places_configuration != null ? [currency_display_format_configuration.value.decimal_places_configuration] : []
                            content {
                              decimal_places = decimal_places_configuration.value.decimal_places
                            }
                          }

                          dynamic "negative_value_configuration" {
                            for_each = currency_display_format_configuration.value.negative_value_configuration != null ? [currency_display_format_configuration.value.negative_value_configuration] : []
                            content {
                              display_mode = negative_value_configuration.value.display_mode
                            }
                          }

                          dynamic "null_value_format_configuration" {
                            for_each = currency_display_format_configuration.value.null_value_format_configuration != null ? [currency_display_format_configuration.value.null_value_format_configuration] : []
                            content {
                              null_string = null_value_format_configuration.value.null_string
                            }
                          }

                          number_scale = currency_display_format_configuration.value.number_scale
                          prefix       = currency_display_format_configuration.value.prefix

                          dynamic "separator_configuration" {
                            for_each = currency_display_format_configuration.value.separator_configuration != null ? [currency_display_format_configuration.value.separator_configuration] : []
                            content {
                              decimal_separator = separator_configuration.value.decimal_separator

                              dynamic "thousands_separator" {
                                for_each = separator_configuration.value.thousands_separator != null ? [separator_configuration.value.thousands_separator] : []
                                content {
                                  symbol     = thousands_separator.value.symbol
                                  visibility = thousands_separator.value.visibility
                                }
                              }
                            }
                          }

                          suffix = currency_display_format_configuration.value.suffix
                          symbol = currency_display_format_configuration.value.symbol
                        }
                      }

                      dynamic "number_display_format_configuration" {
                        for_each = numeric_format_configuration.value.number_display_format_configuration != null ? [numeric_format_configuration.value.number_display_format_configuration] : []
                        content {
                          dynamic "decimal_places_configuration" {
                            for_each = number_display_format_configuration.value.decimal_places_configuration != null ? [number_display_format_configuration.value.decimal_places_configuration] : []
                            content {
                              decimal_places = decimal_places_configuration.value.decimal_places
                            }
                          }

                          dynamic "negative_value_configuration" {
                            for_each = number_display_format_configuration.value.negative_value_configuration != null ? [number_display_format_configuration.value.negative_value_configuration] : []
                            content {
                              display_mode = negative_value_configuration.value.display_mode
                            }
                          }

                          dynamic "null_value_format_configuration" {
                            for_each = number_display_format_configuration.value.null_value_format_configuration != null ? [number_display_format_configuration.value.null_value_format_configuration] : []
                            content {
                              null_string = null_value_format_configuration.value.null_string
                            }
                          }

                          number_scale = number_display_format_configuration.value.number_scale
                          prefix       = number_display_format_configuration.value.prefix

                          dynamic "separator_configuration" {
                            for_each = number_display_format_configuration.value.separator_configuration != null ? [number_display_format_configuration.value.separator_configuration] : []
                            content {
                              decimal_separator = separator_configuration.value.decimal_separator

                              dynamic "thousands_separator" {
                                for_each = separator_configuration.value.thousands_separator != null ? [separator_configuration.value.thousands_separator] : []
                                content {
                                  symbol     = thousands_separator.value.symbol
                                  visibility = thousands_separator.value.visibility
                                }
                              }
                            }
                          }

                          suffix = number_display_format_configuration.value.suffix
                        }
                      }

                      dynamic "percentage_display_format_configuration" {
                        for_each = numeric_format_configuration.value.percentage_display_format_configuration != null ? [numeric_format_configuration.value.percentage_display_format_configuration] : []
                        content {
                          dynamic "decimal_places_configuration" {
                            for_each = percentage_display_format_configuration.value.decimal_places_configuration != null ? [percentage_display_format_configuration.value.decimal_places_configuration] : []
                            content {
                              decimal_places = decimal_places_configuration.value.decimal_places
                            }
                          }

                          dynamic "negative_value_configuration" {
                            for_each = percentage_display_format_configuration.value.negative_value_configuration != null ? [percentage_display_format_configuration.value.negative_value_configuration] : []
                            content {
                              display_mode = negative_value_configuration.value.display_mode
                            }
                          }

                          dynamic "null_value_format_configuration" {
                            for_each = percentage_display_format_configuration.value.null_value_format_configuration != null ? [percentage_display_format_configuration.value.null_value_format_configuration] : []
                            content {
                              null_string = null_value_format_configuration.value.null_string
                            }
                          }

                          prefix = percentage_display_format_configuration.value.prefix

                          dynamic "separator_configuration" {
                            for_each = percentage_display_format_configuration.value.separator_configuration != null ? [percentage_display_format_configuration.value.separator_configuration] : []
                            content {
                              decimal_separator = separator_configuration.value.decimal_separator

                              dynamic "thousands_separator" {
                                for_each = separator_configuration.value.thousands_separator != null ? [separator_configuration.value.thousands_separator] : []
                                content {
                                  symbol     = thousands_separator.value.symbol
                                  visibility = thousands_separator.value.visibility
                                }
                              }
                            }
                          }

                          suffix = percentage_display_format_configuration.value.suffix
                        }
                      }
                    }
                  }
                }
              }
            }
          }

          role = column_configurations.value.role
        }
      }

      dynamic "filter_groups" {
        for_each = definition.value.filter_groups != null ? definition.value.filter_groups : []
        content {
          cross_dataset   = filter_groups.value.cross_dataset
          filter_group_id = filter_groups.value.filter_group_id

          dynamic "filters" {
            for_each = filter_groups.value.filters != null ? filter_groups.value.filters : []
            content {
              # Placeholder for filter content
            }
          }

          dynamic "scope_configuration" {
            for_each = [filter_groups.value.scope_configuration]
            content {
              dynamic "selected_sheets" {
                for_each = scope_configuration.value.selected_sheets != null ? [scope_configuration.value.selected_sheets] : []
                content {
                  dynamic "sheet_visual_scoping_configurations" {
                    for_each = selected_sheets.value.sheet_visual_scoping_configurations != null ? selected_sheets.value.sheet_visual_scoping_configurations : []
                    content {
                      sheet_id   = sheet_visual_scoping_configurations.value.sheet_id
                      scope      = sheet_visual_scoping_configurations.value.scope
                      visual_ids = sheet_visual_scoping_configurations.value.visual_ids
                    }
                  }
                }
              }
            }
          }

          status = filter_groups.value.status
        }
      }

      dynamic "parameter_declarations" {
        for_each = definition.value.parameter_declarations != null ? definition.value.parameter_declarations : []
        content {
          dynamic "date_time_parameter_declaration" {
            for_each = parameter_declarations.value.date_time_parameter_declaration != null ? [parameter_declarations.value.date_time_parameter_declaration] : []
            content {
              name = date_time_parameter_declaration.value.name

              dynamic "default_values" {
                for_each = date_time_parameter_declaration.value.default_values != null ? [date_time_parameter_declaration.value.default_values] : []
                content {
                  dynamic "dynamic_value" {
                    for_each = default_values.value.dynamic_value != null ? [default_values.value.dynamic_value] : []
                    content {
                      dynamic "default_value_column" {
                        for_each = [dynamic_value.value.default_value_column]
                        content {
                          column_name         = default_value_column.value.column_name
                          data_set_identifier = default_value_column.value.data_set_identifier
                        }
                      }

                      dynamic "group_name_column" {
                        for_each = dynamic_value.value.group_name_column != null ? [dynamic_value.value.group_name_column] : []
                        content {
                          column_name         = group_name_column.value.column_name
                          data_set_identifier = group_name_column.value.data_set_identifier
                        }
                      }

                      dynamic "user_name_column" {
                        for_each = dynamic_value.value.user_name_column != null ? [dynamic_value.value.user_name_column] : []
                        content {
                          column_name         = user_name_column.value.column_name
                          data_set_identifier = user_name_column.value.data_set_identifier
                        }
                      }
                    }
                  }

                  dynamic "rolling_date" {
                    for_each = default_values.value.rolling_date != null ? [default_values.value.rolling_date] : []
                    content {
                      data_set_identifier = rolling_date.value.data_set_identifier
                      expression          = rolling_date.value.expression
                    }
                  }

                  static_values = default_values.value.static_values
                }
              }


              time_granularity = date_time_parameter_declaration.value.time_granularity

              dynamic "values_when_unset" {
                for_each = date_time_parameter_declaration.value.values_when_unset != null ? [date_time_parameter_declaration.value.values_when_unset] : []
                content {
                  custom_value            = values_when_unset.value.custom_value
                  value_when_unset_option = values_when_unset.value.value_when_unset_option
                }
              }
            }
          }

          dynamic "decimal_parameter_declaration" {
            for_each = parameter_declarations.value.decimal_parameter_declaration != null ? [parameter_declarations.value.decimal_parameter_declaration] : []
            content {
              name                 = decimal_parameter_declaration.value.name
              parameter_value_type = decimal_parameter_declaration.value.parameter_value_type != null ? decimal_parameter_declaration.value.parameter_value_type : "SINGLE_VALUED"

              dynamic "default_values" {
                for_each = decimal_parameter_declaration.value.default_values != null ? [decimal_parameter_declaration.value.default_values] : []
                content {
                  dynamic "dynamic_value" {
                    for_each = default_values.value.dynamic_value != null ? [default_values.value.dynamic_value] : []
                    content {
                      dynamic "default_value_column" {
                        for_each = [dynamic_value.value.default_value_column]
                        content {
                          column_name         = default_value_column.value.column_name
                          data_set_identifier = default_value_column.value.data_set_identifier
                        }
                      }

                      dynamic "group_name_column" {
                        for_each = dynamic_value.value.group_name_column != null ? [dynamic_value.value.group_name_column] : []
                        content {
                          column_name         = group_name_column.value.column_name
                          data_set_identifier = group_name_column.value.data_set_identifier
                        }
                      }

                      dynamic "user_name_column" {
                        for_each = dynamic_value.value.user_name_column != null ? [dynamic_value.value.user_name_column] : []
                        content {
                          column_name         = user_name_column.value.column_name
                          data_set_identifier = user_name_column.value.data_set_identifier
                        }
                      }
                    }
                  }

                  static_values = default_values.value.static_values
                }
              }



              dynamic "values_when_unset" {
                for_each = decimal_parameter_declaration.value.values_when_unset != null ? [decimal_parameter_declaration.value.values_when_unset] : []
                content {
                  custom_value            = values_when_unset.value.custom_value
                  value_when_unset_option = values_when_unset.value.value_when_unset_option
                }
              }
            }
          }

          dynamic "integer_parameter_declaration" {
            for_each = parameter_declarations.value.integer_parameter_declaration != null ? [parameter_declarations.value.integer_parameter_declaration] : []
            content {
              name                 = integer_parameter_declaration.value.name
              parameter_value_type = integer_parameter_declaration.value.parameter_value_type != null ? integer_parameter_declaration.value.parameter_value_type : "SINGLE_VALUED"

              dynamic "default_values" {
                for_each = integer_parameter_declaration.value.default_values != null ? [integer_parameter_declaration.value.default_values] : []
                content {
                  dynamic "dynamic_value" {
                    for_each = default_values.value.dynamic_value != null ? [default_values.value.dynamic_value] : []
                    content {
                      dynamic "default_value_column" {
                        for_each = [dynamic_value.value.default_value_column]
                        content {
                          column_name         = default_value_column.value.column_name
                          data_set_identifier = default_value_column.value.data_set_identifier
                        }
                      }

                      dynamic "group_name_column" {
                        for_each = dynamic_value.value.group_name_column != null ? [dynamic_value.value.group_name_column] : []
                        content {
                          column_name         = group_name_column.value.column_name
                          data_set_identifier = group_name_column.value.data_set_identifier
                        }
                      }

                      dynamic "user_name_column" {
                        for_each = dynamic_value.value.user_name_column != null ? [dynamic_value.value.user_name_column] : []
                        content {
                          column_name         = user_name_column.value.column_name
                          data_set_identifier = user_name_column.value.data_set_identifier
                        }
                      }
                    }
                  }

                  static_values = default_values.value.static_values
                }
              }



              dynamic "values_when_unset" {
                for_each = integer_parameter_declaration.value.values_when_unset != null ? [integer_parameter_declaration.value.values_when_unset] : []
                content {
                  custom_value            = values_when_unset.value.custom_value
                  value_when_unset_option = values_when_unset.value.value_when_unset_option
                }
              }
            }
          }

          dynamic "string_parameter_declaration" {
            for_each = parameter_declarations.value.string_parameter_declaration != null ? [parameter_declarations.value.string_parameter_declaration] : []
            content {
              name                 = string_parameter_declaration.value.name
              parameter_value_type = string_parameter_declaration.value.parameter_value_type != null ? string_parameter_declaration.value.parameter_value_type : "SINGLE_VALUED"

              dynamic "default_values" {
                for_each = string_parameter_declaration.value.default_values != null ? [string_parameter_declaration.value.default_values] : []
                content {
                  dynamic "dynamic_value" {
                    for_each = default_values.value.dynamic_value != null ? [default_values.value.dynamic_value] : []
                    content {
                      dynamic "default_value_column" {
                        for_each = [dynamic_value.value.default_value_column]
                        content {
                          column_name         = default_value_column.value.column_name
                          data_set_identifier = default_value_column.value.data_set_identifier
                        }
                      }

                      dynamic "group_name_column" {
                        for_each = dynamic_value.value.group_name_column != null ? [dynamic_value.value.group_name_column] : []
                        content {
                          column_name         = group_name_column.value.column_name
                          data_set_identifier = group_name_column.value.data_set_identifier
                        }
                      }

                      dynamic "user_name_column" {
                        for_each = dynamic_value.value.user_name_column != null ? [dynamic_value.value.user_name_column] : []
                        content {
                          column_name         = user_name_column.value.column_name
                          data_set_identifier = user_name_column.value.data_set_identifier
                        }
                      }
                    }
                  }

                  static_values = default_values.value.static_values
                }
              }



              dynamic "values_when_unset" {
                for_each = string_parameter_declaration.value.values_when_unset != null ? [string_parameter_declaration.value.values_when_unset] : []
                content {
                  custom_value            = values_when_unset.value.custom_value
                  value_when_unset_option = values_when_unset.value.value_when_unset_option
                }
              }
            }
          }
        }
      }

      dynamic "sheets" {
        for_each = definition.value.sheets != null ? definition.value.sheets : []
        content {
          sheet_id = sheets.value.sheet_id != null ? sheets.value.sheet_id : "default-sheet"
          # Placeholder for other sheet content
        }
      }
    }
  }

  dynamic "parameters" {
    for_each = var.parameters != null ? [var.parameters] : []
    content {
      dynamic "date_time_parameters" {
        for_each = parameters.value.date_time_parameters != null ? parameters.value.date_time_parameters : []
        content {
          name   = date_time_parameters.value.name
          values = date_time_parameters.value.values
        }
      }

      dynamic "decimal_parameters" {
        for_each = parameters.value.decimal_parameters != null ? parameters.value.decimal_parameters : []
        content {
          name   = decimal_parameters.value.name
          values = decimal_parameters.value.values
        }
      }

      dynamic "integer_parameters" {
        for_each = parameters.value.integer_parameters != null ? parameters.value.integer_parameters : []
        content {
          name   = integer_parameters.value.name
          values = integer_parameters.value.values
        }
      }

      dynamic "string_parameters" {
        for_each = parameters.value.string_parameters != null ? parameters.value.string_parameters : []
        content {
          name   = string_parameters.value.name
          values = string_parameters.value.values
        }
      }
    }
  }

  dynamic "permissions" {
    for_each = var.permissions != null ? var.permissions : []
    content {
      actions   = permissions.value.actions
      principal = permissions.value.principal
    }
  }

  region = var.region

  dynamic "source_entity" {
    for_each = var.source_entity != null ? [var.source_entity] : []
    content {
      dynamic "source_template" {
        for_each = source_entity.value.source_template != null ? [source_entity.value.source_template] : []
        content {
          arn = source_template.value.arn

          dynamic "data_set_references" {
            for_each = source_template.value.data_set_references
            content {
              data_set_arn         = data_set_references.value.data_set_arn
              data_set_placeholder = data_set_references.value.data_set_placeholder
            }
          }
        }
      }
    }
  }

  tags      = var.tags
  theme_arn = var.theme_arn

  timeouts {
    create = "5m"
    update = "5m"
    delete = "5m"
  }
}