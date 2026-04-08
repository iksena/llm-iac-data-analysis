resource "aws_quicksight_data_set" "this" {
  data_set_id    = var.data_set_id
  import_mode    = var.import_mode
  name           = var.name
  aws_account_id = var.aws_account_id
  region         = var.region
  tags           = var.tags

  dynamic "column_groups" {
    for_each = var.column_groups
    content {
      dynamic "geo_spatial_column_group" {
        for_each = column_groups.value.geo_spatial_column_group != null ? [column_groups.value.geo_spatial_column_group] : []
        content {
          columns      = geo_spatial_column_group.value.columns
          country_code = geo_spatial_column_group.value.country_code
          name         = geo_spatial_column_group.value.name
        }
      }
    }
  }

  dynamic "column_level_permission_rules" {
    for_each = var.column_level_permission_rules
    content {
      column_names = column_level_permission_rules.value.column_names
      principals   = column_level_permission_rules.value.principals
    }
  }

  dynamic "data_set_usage_configuration" {
    for_each = var.data_set_usage_configuration != null ? [var.data_set_usage_configuration] : []
    content {
      disable_use_as_direct_query_source = data_set_usage_configuration.value.disable_use_as_direct_query_source
      disable_use_as_imported_source     = data_set_usage_configuration.value.disable_use_as_imported_source
    }
  }

  dynamic "field_folders" {
    for_each = var.field_folders
    content {
      field_folders_id = field_folders.value.field_folders_id
      columns          = field_folders.value.columns
      description      = field_folders.value.description
    }
  }

  dynamic "logical_table_map" {
    for_each = var.logical_table_map != null ? [var.logical_table_map] : []
    content {
      alias                = logical_table_map.value.alias
      logical_table_map_id = logical_table_map.value.logical_table_map_id

      dynamic "data_transforms" {
        for_each = logical_table_map.value.data_transforms
        content {
          dynamic "cast_column_type_operation" {
            for_each = data_transforms.value.cast_column_type_operation != null ? [data_transforms.value.cast_column_type_operation] : []
            content {
              column_name     = cast_column_type_operation.value.column_name
              new_column_type = cast_column_type_operation.value.new_column_type
              format          = cast_column_type_operation.value.format
            }
          }

          dynamic "create_columns_operation" {
            for_each = data_transforms.value.create_columns_operation != null ? [data_transforms.value.create_columns_operation] : []
            content {
              dynamic "columns" {
                for_each = create_columns_operation.value.columns
                content {
                  column_id   = columns.value.column_id
                  column_name = columns.value.column_name
                  expression  = columns.value.expression
                }
              }
            }
          }

          dynamic "filter_operation" {
            for_each = data_transforms.value.filter_operation != null ? [data_transforms.value.filter_operation] : []
            content {
              condition_expression = filter_operation.value.condition_expression
            }
          }

          dynamic "project_operation" {
            for_each = data_transforms.value.project_operation != null ? [data_transforms.value.project_operation] : []
            content {
              projected_columns = project_operation.value.projected_columns
            }
          }

          dynamic "rename_column_operation" {
            for_each = data_transforms.value.rename_column_operation != null ? [data_transforms.value.rename_column_operation] : []
            content {
              column_name     = rename_column_operation.value.column_name
              new_column_name = rename_column_operation.value.new_column_name
            }
          }

          dynamic "tag_column_operation" {
            for_each = data_transforms.value.tag_column_operation != null ? [data_transforms.value.tag_column_operation] : []
            content {
              column_name = tag_column_operation.value.column_name

              dynamic "tags" {
                for_each = tag_column_operation.value.tags != null ? [tag_column_operation.value.tags] : []
                content {
                  dynamic "column_description" {
                    for_each = tags.value.column_description != null ? [tags.value.column_description] : []
                    content {
                      text = column_description.value.text
                    }
                  }
                  column_geographic_role = tags.value.column_geographic_role
                }
              }
            }
          }

          dynamic "untag_column_operation" {
            for_each = data_transforms.value.untag_column_operation != null ? [data_transforms.value.untag_column_operation] : []
            content {
              column_name = untag_column_operation.value.column_name
              tag_names   = untag_column_operation.value.tag_names
            }
          }
        }
      }

      dynamic "source" {
        for_each = logical_table_map.value.source != null ? [logical_table_map.value.source] : []
        content {
          data_set_arn      = source.value.data_set_arn
          physical_table_id = source.value.physical_table_id

          dynamic "join_instruction" {
            for_each = source.value.join_instruction != null ? [source.value.join_instruction] : []
            content {
              left_operand  = join_instruction.value.left_operand
              on_clause     = join_instruction.value.on_clause
              right_operand = join_instruction.value.right_operand
              type          = join_instruction.value.type

              dynamic "left_join_key_properties" {
                for_each = join_instruction.value.left_join_key_properties != null ? [join_instruction.value.left_join_key_properties] : []
                content {
                  unique_key = left_join_key_properties.value.unique_key
                }
              }

              dynamic "right_join_key_properties" {
                for_each = join_instruction.value.right_join_key_properties != null ? [join_instruction.value.right_join_key_properties] : []
                content {
                  unique_key = right_join_key_properties.value.unique_key
                }
              }
            }
          }
        }
      }
    }
  }

  dynamic "permissions" {
    for_each = var.permissions
    content {
      actions   = permissions.value.actions
      principal = permissions.value.principal
    }
  }

  dynamic "physical_table_map" {
    for_each = var.physical_table_map
    content {
      physical_table_map_id = physical_table_map.value.physical_table_map_id

      dynamic "custom_sql" {
        for_each = physical_table_map.value.custom_sql != null ? [physical_table_map.value.custom_sql] : []
        content {
          data_source_arn = custom_sql.value.data_source_arn
          name            = custom_sql.value.name
          sql_query       = custom_sql.value.sql_query

          dynamic "columns" {
            for_each = custom_sql.value.columns
            content {
              name = columns.value.name
              type = columns.value.type
            }
          }
        }
      }

      dynamic "relational_table" {
        for_each = physical_table_map.value.relational_table != null ? [physical_table_map.value.relational_table] : []
        content {
          data_source_arn = relational_table.value.data_source_arn
          name            = relational_table.value.name
          catalog         = relational_table.value.catalog
          schema          = relational_table.value.schema

          dynamic "input_columns" {
            for_each = relational_table.value.input_columns
            content {
              name = input_columns.value.name
              type = input_columns.value.type
            }
          }
        }
      }

      dynamic "s3_source" {
        for_each = physical_table_map.value.s3_source != null ? [physical_table_map.value.s3_source] : []
        content {
          data_source_arn = s3_source.value.data_source_arn

          dynamic "input_columns" {
            for_each = s3_source.value.input_columns
            content {
              name = input_columns.value.name
              type = input_columns.value.type
            }
          }

          dynamic "upload_settings" {
            for_each = s3_source.value.upload_settings != null ? [s3_source.value.upload_settings] : []
            content {
              contains_header = upload_settings.value.contains_header
              delimiter       = upload_settings.value.delimiter
              format          = upload_settings.value.format
              start_from_row  = upload_settings.value.start_from_row
              text_qualifier  = upload_settings.value.text_qualifier
            }
          }
        }
      }
    }
  }

  dynamic "row_level_permission_data_set" {
    for_each = var.row_level_permission_data_set != null ? [var.row_level_permission_data_set] : []
    content {
      arn               = row_level_permission_data_set.value.arn
      permission_policy = row_level_permission_data_set.value.permission_policy
      format_version    = row_level_permission_data_set.value.format_version
      namespace         = row_level_permission_data_set.value.namespace
      status            = row_level_permission_data_set.value.status
    }
  }

  dynamic "row_level_permission_tag_configuration" {
    for_each = var.row_level_permission_tag_configuration != null ? [var.row_level_permission_tag_configuration] : []
    content {
      status = row_level_permission_tag_configuration.value.status

      dynamic "tag_rules" {
        for_each = row_level_permission_tag_configuration.value.tag_rules
        content {
          column_name               = tag_rules.value.column_name
          tag_key                   = tag_rules.value.tag_key
          match_all_value           = tag_rules.value.match_all_value
          tag_multi_value_delimiter = tag_rules.value.tag_multi_value_delimiter
        }
      }
    }
  }

  dynamic "refresh_properties" {
    for_each = var.refresh_properties != null ? [var.refresh_properties] : []
    content {
      dynamic "refresh_configuration" {
        for_each = refresh_properties.value.refresh_configuration != null ? [refresh_properties.value.refresh_configuration] : []
        content {
          dynamic "incremental_refresh" {
            for_each = refresh_configuration.value.incremental_refresh != null ? [refresh_configuration.value.incremental_refresh] : []
            content {
              dynamic "lookback_window" {
                for_each = incremental_refresh.value.lookback_window != null ? [incremental_refresh.value.lookback_window] : []
                content {
                  column_name = lookback_window.value.column_name
                  size        = lookback_window.value.size
                  size_unit   = lookback_window.value.size_unit
                }
              }
            }
          }
        }
      }
    }
  }
}