locals {
  metadata = {
    package = "terraform-aws-quicksight"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = var.name
  }
  module_tags = var.module_tags_enabled ? {
    "module.terraform.io/package"   = local.metadata.package
    "module.terraform.io/version"   = local.metadata.version
    "module.terraform.io/name"      = local.metadata.module
    "module.terraform.io/instance"  = local.metadata.name
    "module.terraform.io/full-name" = "${local.metadata.package}/${local.metadata.module}"
  } : {}
}

data "aws_caller_identity" "this" {}

locals {
  account_id = data.aws_caller_identity.this.account_id

  role_actions = {
    "OWNER" = [
      "quicksight:DeleteDataSet",
      "quicksight:UpdateDataSetPermissions",
      "quicksight:PutDataSetRefreshProperties",
      "quicksight:CreateRefreshSchedule",
      "quicksight:CancelIngestion",
      "quicksight:UpdateRefreshSchedule",
      "quicksight:ListRefreshSchedules",
      "quicksight:DeleteRefreshSchedule",
      "quicksight:PassDataSet",
      "quicksight:DescribeDataSetRefreshProperties",
      "quicksight:DescribeDataSet",
      "quicksight:CreateIngestion",
      "quicksight:DescribeRefreshSchedule",
      "quicksight:ListIngestions",
      "quicksight:UpdateDataSet",
      "quicksight:DescribeDataSetPermissions",
      "quicksight:DeleteDataSetRefreshProperties",
      "quicksight:DescribeIngestion",
    ]
    "USER" = [
      "quicksight:DescribeRefreshSchedule",
      "quicksight:ListIngestions",
      "quicksight:DescribeDataSetPermissions",
      "quicksight:PassDataSet",
      "quicksight:ListRefreshSchedules",
      "quicksight:DescribeDataSet",
      "quicksight:DescribeIngestion",
    ]
  }
}


###################################################
# QuickSight Data Set
###################################################

# TODO:
# - `row_level_permission_tag_configuration`
resource "aws_quicksight_data_set" "this" {
  region = var.region

  aws_account_id = local.account_id

  data_set_id = var.name
  name        = coalesce(var.display_name, var.name)

  import_mode = var.import_mode

  dynamic "physical_table_map" {
    for_each = var.physical_tables
    iterator = table

    content {
      physical_table_map_id = table.key

      dynamic "s3_source" {
        for_each = table.value.type == "S3" ? [table.value.s3] : []
        iterator = s3

        content {
          data_source_arn = table.value.data_source

          dynamic "input_columns" {
            for_each = s3.value.input_columns
            iterator = column

            content {
              name = column.value.name
              type = column.value.type
            }
          }

          dynamic "upload_settings" {
            for_each = try([s3.value.upload_settings], [])

            content {
              format          = upload_settings.value.format
              start_from_row  = upload_settings.value.starting_row
              contains_header = upload_settings.value.header_included
              delimiter       = upload_settings.value.delimiter
              text_qualifier  = upload_settings.value.text_qualifier
            }
          }
        }
      }

      dynamic "relational_table" {
        for_each = table.value.type == "RELATIONAL_TABLE" ? [table.value.relational_table] : []

        content {
          data_source_arn = table.value.data_source
          catalog         = try(relational_table.value.catalog, null)
          schema          = try(relational_table.value.schema, null)
          name            = relational_table.value.table

          dynamic "input_columns" {
            for_each = relational_table.value.input_columns
            iterator = column

            content {
              name = column.value.name
              type = column.value.type
            }
          }
        }
      }

      dynamic "custom_sql" {
        for_each = table.value.type == "CUSTOM_SQL" ? [table.value.custom_sql] : []

        content {
          data_source_arn = table.value.data_source
          name            = custom_sql.value.name
          sql_query       = custom_sql.value.sql_query

          dynamic "columns" {
            for_each = custom_sql.value.input_columns
            iterator = column

            content {
              name = column.value.name
              type = column.value.type
            }
          }
        }
      }
    }
  }

  dynamic "logical_table_map" {
    for_each = var.logical_tables
    iterator = table

    content {
      logical_table_map_id = table.key
      alias                = table.value.alias

      dynamic "source" {
        for_each = [table.value.source]
        iterator = source

        content {
          physical_table_id = (source.value.type == "PHYSICAL_TABLE"
            ? source.value.physical_table
            : null
          )
          data_set_arn = (source.value.type == "DATA_SET"
            ? source.value.data_set
            : null
          )

          dynamic "join_instruction" {
            for_each = (source.value.type == "JOIN"
              ? [source.value.join]
              : []
            )
            iterator = join

            content {
              left_operand  = join.value.left_operand
              right_operand = join.value.right_operand
              type          = join.value.type
              on_clause     = join.value.on_clause

              dynamic "left_join_key_properties" {
                for_each = join.value.left_join_key_properties != null ? [join.value.left_join_key_properties] : []
                iterator = properties

                content {
                  unique_key = properties.value.unique_key
                }
              }
              dynamic "right_join_key_properties" {
                for_each = join.value.right_join_key_properties != null ? [join.value.right_join_key_properties] : []
                iterator = properties

                content {
                  unique_key = properties.value.unique_key
                }
              }
            }
          }
        }
      }

      dynamic "data_transforms" {
        for_each = table.value.data_transforms
        iterator = transform

        content {
          dynamic "cast_column_type_operation" {
            for_each = transform.value.cast_column_type != null ? [transform.value.cast_column_type] : []
            iterator = operation

            content {
              column_name     = operation.value.column
              new_column_type = operation.value.new_type
              format          = operation.value.format
            }
          }

          dynamic "create_columns_operation" {
            for_each = transform.value.create_columns != null ? [transform.value.create_columns] : []
            iterator = operation

            content {
              dynamic "columns" {
                for_each = operation.value.columns
                iterator = column

                content {
                  column_id   = column.value.id
                  column_name = column.value.name
                  expression  = column.value.expression
                }
              }
            }
          }

          dynamic "filter_operation" {
            for_each = transform.value.filter != null ? [transform.value.filter] : []
            iterator = operation

            content {
              condition_expression = operation.value.condition
            }
          }

          dynamic "project_operation" {
            for_each = transform.value.project != null ? [transform.value.project] : []
            iterator = operation

            content {
              projected_columns = operation.value.columns
            }
          }

          dynamic "rename_column_operation" {
            for_each = transform.value.rename_column != null ? [transform.value.rename_column] : []
            iterator = operation

            content {
              column_name     = operation.value.column
              new_column_name = operation.value.new_name
            }
          }

          dynamic "tag_column_operation" {
            for_each = transform.value.tag_column != null ? [transform.value.tag_column] : []
            iterator = operation

            content {
              column_name = operation.value.column

              dynamic "tags" {
                for_each = operation.value.tags
                iterator = tag

                content {
                  column_geographic_role = tag.value.geographic_role

                  column_description {
                    text = tag.value.description
                  }
                }
              }
            }
          }

          dynamic "untag_column_operation" {
            for_each = transform.value.untag_column != null ? [transform.value.untag_column] : []
            iterator = operation

            content {
              column_name = operation.value.column
              tag_names   = operation.value.tags
            }
          }
        }
      }
    }
  }

  dynamic "refresh_properties" {
    for_each = anytrue([
      for config in var.refresh_config :
      config != null
    ]) ? [var.refresh_config] : []
    iterator = refresh

    content {
      dynamic "refresh_configuration" {
        for_each = anytrue([
          for config in refresh.value :
          config != null
        ]) ? [refresh.value] : []

        content {
          incremental_refresh {
            dynamic "lookback_window" {
              for_each = (refresh.value.incremental_refresh_lookback_window != null
                ? [refresh.value.incremental_refresh_lookback_window]
                : []
              )
              iterator = window

              content {
                column_name = window.value.column
                size        = window.value.size
                size_unit   = window.value.unit
              }
            }
          }
        }
      }
    }
  }

  # Geo Spatial Column Groups
  dynamic "column_groups" {
    for_each = var.geo_spatial_column_groups
    iterator = column_group

    content {
      geo_spatial_column_group {
        name         = column_group.value.name
        country_code = column_group.value.country_code
        columns      = column_group.value.columns
      }
    }
  }

  dynamic "field_folders" {
    for_each = var.column_folders
    iterator = folder

    content {
      field_folders_id = folder.key
      columns          = folder.value.columns
      description      = folder.value.description
    }
  }


  ## Access Control
  dynamic "permissions" {
    for_each = var.permissions
    iterator = permission

    content {
      principal = permission.value.principal
      actions = (permission.value.role != null
        ? local.role_actions[permission.value.role]
        : permission.value.actions
      )
    }
  }

  dynamic "row_level_permission_data_set" {
    for_each = var.row_level_permission_data_set != null ? [var.row_level_permission_data_set] : []

    content {
      arn               = row_level_permission_data_set.value.arn
      permission_policy = row_level_permission_data_set.value.permission_policy
      format_version    = try(row_level_permission_data_set.value.format_version, null)
      namespace         = try(row_level_permission_data_set.value.namespace, null)
      status            = try(row_level_permission_data_set.value.status, null)
    }
  }

  dynamic "column_level_permission_rules" {
    for_each = var.column_level_permission_rules
    iterator = rule

    content {
      column_names = rule.value.columns
      principals   = rule.value.principals
    }
  }

  data_set_usage_configuration {
    disable_use_as_direct_query_source = !var.data_set_usage.use_as_direct_query_source
    disable_use_as_imported_source     = !var.data_set_usage.use_as_imported_source
  }

  tags = merge(
    local.module_tags,
    var.tags,
  )
}
