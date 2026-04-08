resource "aws_quicksight_template" "this" {
  template_id         = var.template_id
  name                = var.name
  version_description = var.version_description
  aws_account_id      = var.aws_account_id
  tags                = var.tags

  dynamic "definition" {
    for_each = var.definition != null ? [var.definition] : []
    content {

      dynamic "data_set_configuration" {
        for_each = definition.value.data_set_configuration != null ? definition.value.data_set_configuration : []
        content {
          placeholder = data_set_configuration.value.placeholder

          dynamic "data_set_schema" {
            for_each = data_set_configuration.value.data_set_schema != null ? [data_set_configuration.value.data_set_schema] : []
            content {

              dynamic "column_schema_list" {
                for_each = data_set_schema.value.column_schema_list != null ? data_set_schema.value.column_schema_list : []
                content {
                  name            = column_schema_list.value.name
                  data_type       = column_schema_list.value.data_type
                  geographic_role = column_schema_list.value.geographic_role
                }
              }
            }
          }
        }
      }

      dynamic "analysis_defaults" {
        for_each = definition.value.analysis_defaults != null ? [definition.value.analysis_defaults] : []
        content {

          dynamic "default_new_sheet_configuration" {
            for_each = analysis_defaults.value.default_new_sheet_configuration != null ? [analysis_defaults.value.default_new_sheet_configuration] : []
            content {
              sheet_content_type = default_new_sheet_configuration.value.sheet_content_type

            }
          }
        }
      }

      dynamic "calculated_fields" {
        for_each = definition.value.calculated_fields != null ? definition.value.calculated_fields : []
        content {
          name                = calculated_fields.value.name
          data_set_identifier = calculated_fields.value.data_set_identifier
          expression          = calculated_fields.value.expression
        }
      }

      dynamic "column_configurations" {
        for_each = definition.value.column_configurations != null ? definition.value.column_configurations : []
        content {
          role = column_configurations.value.role

          dynamic "column" {
            for_each = column_configurations.value.column != null ? [column_configurations.value.column] : []
            content {
              column_name         = column.value.column_name
              data_set_identifier = column.value.data_set_identifier
            }
          }
        }
      }

      dynamic "filter_groups" {
        for_each = definition.value.filter_groups != null ? definition.value.filter_groups : []
        content {
          cross_dataset   = filter_groups.value.cross_dataset
          filter_group_id = filter_groups.value.filter_group_id
          status          = filter_groups.value.status

          dynamic "filters" {
            for_each = filter_groups.value.filters != null ? filter_groups.value.filters : []
            content {
              # filters are complex objects that vary by type
              # keeping as generic any for now since the variable defines them as list(any)
            }
          }

          dynamic "scope_configuration" {
            for_each = [1]
            content {

              dynamic "selected_sheets" {
                for_each = filter_groups.value.scope_configuration != null && filter_groups.value.scope_configuration.selected_sheets != null ? [filter_groups.value.scope_configuration.selected_sheets] : []
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
        }
      }

      dynamic "parameters_declarations" {
        for_each = definition.value.parameters_declarations != null ? definition.value.parameters_declarations : []
        content {

          dynamic "date_time_parameter_declaration" {
            for_each = parameters_declarations.value.date_time_parameter_declaration != null ? [parameters_declarations.value.date_time_parameter_declaration] : []
            content {
              name             = date_time_parameter_declaration.value.name
              time_granularity = date_time_parameter_declaration.value.time_granularity

              dynamic "default_values" {
                for_each = date_time_parameter_declaration.value.default_values != null ? [date_time_parameter_declaration.value.default_values] : []
                content {
                  static_values = default_values.value.static_values

                  dynamic "dynamic_value" {
                    for_each = default_values.value.dynamic_value != null ? [default_values.value.dynamic_value] : []
                    content {

                      dynamic "default_value_column" {
                        for_each = [1]
                        content {
                          column_name         = dynamic_value.value.default_value_column.column_name
                          data_set_identifier = dynamic_value.value.default_value_column.data_set_identifier
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
                }
              }
            }
          }

          dynamic "decimal_parameter_declaration" {
            for_each = parameters_declarations.value.decimal_parameter_declaration != null ? [parameters_declarations.value.decimal_parameter_declaration] : []
            content {
              name                 = decimal_parameter_declaration.value.name
              parameter_value_type = decimal_parameter_declaration.value.parameter_value_type

              dynamic "default_values" {
                for_each = decimal_parameter_declaration.value.default_values != null ? [decimal_parameter_declaration.value.default_values] : []
                content {
                  static_values = default_values.value.static_values

                  dynamic "dynamic_value" {
                    for_each = default_values.value.dynamic_value != null ? [default_values.value.dynamic_value] : []
                    content {

                      dynamic "default_value_column" {
                        for_each = [1]
                        content {
                          column_name         = dynamic_value.value.default_value_column.column_name
                          data_set_identifier = dynamic_value.value.default_value_column.data_set_identifier
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
                }
              }
            }
          }

          dynamic "integer_parameter_declaration" {
            for_each = parameters_declarations.value.integer_parameter_declaration != null ? [parameters_declarations.value.integer_parameter_declaration] : []
            content {
              name                 = integer_parameter_declaration.value.name
              parameter_value_type = integer_parameter_declaration.value.parameter_value_type

              dynamic "default_values" {
                for_each = integer_parameter_declaration.value.default_values != null ? [integer_parameter_declaration.value.default_values] : []
                content {
                  static_values = default_values.value.static_values

                  dynamic "dynamic_value" {
                    for_each = default_values.value.dynamic_value != null ? [default_values.value.dynamic_value] : []
                    content {

                      dynamic "default_value_column" {
                        for_each = [1]
                        content {
                          column_name         = dynamic_value.value.default_value_column.column_name
                          data_set_identifier = dynamic_value.value.default_value_column.data_set_identifier
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
                }
              }
            }
          }

          dynamic "string_parameter_declaration" {
            for_each = parameters_declarations.value.string_parameter_declaration != null ? [parameters_declarations.value.string_parameter_declaration] : []
            content {
              name                 = string_parameter_declaration.value.name
              parameter_value_type = string_parameter_declaration.value.parameter_value_type

              dynamic "default_values" {
                for_each = string_parameter_declaration.value.default_values != null ? [string_parameter_declaration.value.default_values] : []
                content {
                  static_values = default_values.value.static_values

                  dynamic "dynamic_value" {
                    for_each = default_values.value.dynamic_value != null ? [default_values.value.dynamic_value] : []
                    content {

                      dynamic "default_value_column" {
                        for_each = [1]
                        content {
                          column_name         = dynamic_value.value.default_value_column.column_name
                          data_set_identifier = dynamic_value.value.default_value_column.data_set_identifier
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
                }
              }
            }
          }
        }
      }

      dynamic "sheets" {
        for_each = definition.value.sheets != null ? definition.value.sheets : []
        content {
          sheet_id    = sheets.value.sheet_id
          description = sheets.value.description
          name        = sheets.value.name
          title       = sheets.value.title
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

  dynamic "source_entity" {
    for_each = var.source_entity != null ? [var.source_entity] : []
    content {

      dynamic "source_analysis" {
        for_each = source_entity.value.source_analysis != null ? [source_entity.value.source_analysis] : []
        content {
          arn = source_analysis.value.arn

          dynamic "data_set_references" {
            for_each = source_analysis.value.data_set_references != null ? source_analysis.value.data_set_references : []
            content {
              data_set_arn         = data_set_references.value.data_set_arn
              data_set_placeholder = data_set_references.value.data_set_placeholder
            }
          }
        }
      }

      dynamic "source_template" {
        for_each = source_entity.value.source_template != null ? [source_entity.value.source_template] : []
        content {
          arn = source_template.value.arn
        }
      }
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}