locals {
  physical_tables = {
    for table in aws_quicksight_data_set.this.physical_table_map :
    table.physical_table_map_id => {
      id               = table.physical_table_map_id
      type             = var.physical_tables[table.physical_table_map_id].type
      data_source      = var.physical_tables[table.physical_table_map_id].data_source
      s3               = one(table.s3_source[*])
      relational_table = one(table.relational_table[*])
      custom_sql       = one(table.custom_sql[*])
    }
  }
  logical_tables = {
    for table in aws_quicksight_data_set.this.logical_table_map :
    table.logical_table_map_id => {
      id    = table.logical_table_map_id
      alias = table.alias
      source = {
        type = (table.source[0].physical_table_id != ""
          ? "PHYSICAL_TABLE"
          : table.source[0].data_set_arn != ""
          ? "DATA_SET"
          : "JOIN"
        )
        physical_table = table.source[0].physical_table_id
        data_set       = table.source[0].data_set_arn
        join = (length(table.source[0].join_instruction[*]) > 0
          ? {
            left_operand              = one(table.source[0].join_instruction[*].left_operand)
            right_operand             = one(table.source[0].join_instruction[*].right_operand)
            type                      = one(table.source[0].join_instruction[*].type)
            on_clause                 = one(table.source[0].join_instruction[*].on_clause)
            left_join_key_properties  = one(table.source[0].join_instruction[0].left_join_key_properties[*])
            right_join_key_properties = one(table.source[0].join_instruction[0].right_join_key_properties[*])
          }
          : null
        )
      }
      data_transforms = [
        for transform in table.data_transforms : {
          cast_column_type = one(transform.cast_column_type_operation[*])
          create_columns   = one(transform.create_columns_operation[*])
          filter           = one(transform.filter_operation[*])
          project          = one(transform.project_operation[*])
          rename_column    = one(transform.rename_column_operation[*])
          tag_column       = one(transform.tag_column_operation[*])
          untag_column     = one(transform.untag_column_operation[*])
        }
      ]
    }
  }
}

output "region" {
  description = "The AWS region this module resources resides in."
  value       = aws_quicksight_data_set.this.region
}

output "id" {
  description = "The ID of the data set."
  value       = aws_quicksight_data_set.this.data_set_id
}

output "arn" {
  description = "The ARN of the data set."
  value       = aws_quicksight_data_set.this.arn
}

output "name" {
  description = "The identifier of the QuickSight data set."
  value       = aws_quicksight_data_set.this.data_set_id
}

output "display_name" {
  description = "The display name of the QuickSight data set."
  value       = aws_quicksight_data_set.this.name
}

output "import_mode" {
  description = "Whether you want to import the data into SPICE."
  value       = aws_quicksight_data_set.this.import_mode
}

output "physical_tables" {
  description = "A map of physical table configurations. Each entry represents a physical table in the data set."
  value = {
    for id, table in local.physical_tables :
    id => {
      id          = id
      type        = table.type
      data_source = table.data_source

      s3 = (table.type == "S3"
        ? {
          upload_settings = table.s3.upload_settings[0]
          input_columns   = table.s3.input_columns
        }
        : null
      )
      relational_table = (table.type == "RELATIONAL_TABLE"
        ? {
          catalog       = table.relational_table.catalog
          schema        = table.relational_table.schema
          table         = table.relational_table.name
          input_columns = table.relational_table.input_columns
        }
        : null
      )
      custom_sql = (table.type == "CUSTOM_SQL"
        ? {
          name          = table.custom_sql.name
          sql_query     = table.custom_sql.sql_query
          input_columns = table.custom_sql.columns
        }
        : null
      )
    }
  }
}

output "logical_tables" {
  description = "A map of logical table configurations. Each entry represents a logical table in the data set."
  value = {
    for id, table in local.logical_tables :
    id => {
      id    = id
      alias = table.alias
      source = {
        type           = table.source.type
        physical_table = table.source.physical_table
        data_set       = table.source.data_set
        join           = table.source.join
      }
      data_transforms = [
        for transform in table.data_transforms : (
          transform.cast_column_type != null
          ? {
            operation = "cast_column_type"
            parameters = {
              column   = transform.cast_column_type.column_name
              new_type = transform.cast_column_type.new_column_type
              format   = transform.cast_column_type.format
            }
          }
          : transform.create_columns != null
          ? {
            operation = "create_columns"
            parameters = {
              columns = [
                for column in transform.create_columns.columns : {
                  id         = column.column_id
                  name       = column.column_name
                  expression = column.column_expression
                }
              ]
            }
          }
          : transform.filter != null
          ? {
            operation = "filter"
            parameters = {
              condition = transform.filter.condition_expression
            }
          }
          : transform.project != null
          ? {
            operation = "project"
            parameters = {
              columns = transform.project.projected_columns
            }
          }
          : transform.rename_column != null
          ? {
            operation = "rename_column"
            parameters = {
              column   = transform.rename_column.column_name
              new_name = transform.rename_column.new_column_name
            }
          }
          : transform.tag_column != null
          ? {
            operation = "tag_column"
            parameters = {
              column = transform.tag_column.column_name
              tags = [
                for tag in transform.tag_column.tags : {
                  description     = one(tag.column_description[*].text)
                  geographic_role = tag.column_geographic_role
                }
              ]
            }
          }
          : transform.untag_column != null
          ? {
            operation = "untag_column"
            parameters = {
              column = transform.untag_column.column_name
              tags   = transform.untag_column.tag_names
            }
          }
          : null
        )
      ]
    }
  }
}

output "output_columns" {
  description = "The final set of columns available for use in analyses and dashboards after all data preparation and transformation steps have been applied within the dataset."
  value       = aws_quicksight_data_set.this.output_columns
}

output "column_folders" {
  description = "A map of column folders in the data set."
  value = {
    for folder in aws_quicksight_data_set.this.field_folders :
    folder.field_folders_id => {
      id          = folder.field_folders_id
      columns     = folder.columns
      description = folder.description
    }
  }
}

output "geo_spatial_column_groups" {
  description = "A list of geospatial column groups in the data set."
  value = {
    for group in aws_quicksight_data_set.this.column_groups :
    group.geo_spatial_column_group[0].name => {
      name         = group.geo_spatial_column_group[0].name
      country_code = group.geo_spatial_column_group[0].country_code
      columns      = group.geo_spatial_column_group[0].columns
    }
    if one(group.geo_spatial_column_group[*]) != null
  }
}

output "refresh_config" {
  description = "The refresh configuration for the data set."
  value = {
    incremental_refresh_lookback_window = (var.refresh_config.incremental_refresh_lookback_window != null
      ? {
        column = aws_quicksight_data_set.this.refresh_properties[0].refresh_configuration[0].incremental_refresh[0].lookback_window[0].column_name
        size   = aws_quicksight_data_set.this.refresh_properties[0].refresh_configuration[0].incremental_refresh[0].lookback_window[0].size
        unit   = aws_quicksight_data_set.this.refresh_properties[0].refresh_configuration[0].incremental_refresh[0].lookback_window[0].size_unit
      }
      : null
    )
  }
}

output "refresh_schedules" {
  description = "A list of refresh schedules for the data set."
  value = [
    for schedule in aws_quicksight_refresh_schedule.this : {
      arn = schedule.arn
      id  = schedule.schedule_id
      refresh_type = {
        for k, v in local.refresh_types :
        v => k
      }[schedule.schedule[0].refresh_type]
      start_at = schedule.schedule[0].start_after_date_time
      schedule_frequency = {
        timezone    = one(schedule.schedule[0].schedule_frequency[*].timezone)
        interval    = one(schedule.schedule[0].schedule_frequency[*].interval)
        time_of_day = one(schedule.schedule[0].schedule_frequency[*].time_of_the_day)
        day_of_week = (one(schedule.schedule[0].schedule_frequency[*].interval) == "WEEKLY"
          ? one(schedule.schedule[0].schedule_frequency[*].refresh_on_day[0].day_of_week)
          : null
        )
        day_of_month = (one(schedule.schedule[0].schedule_frequency[*].interval) == "MONTHLY"
          ? one(schedule.schedule[0].schedule_frequency[*].refresh_on_day[0].day_of_month)
          : null
        )
      }
    }
  ]
}

output "refresh_ingestions" {
  description = "A list of refresh ingestions for the data set."
  value = [
    for ingestion in aws_quicksight_ingestion.this : {
      arn    = ingestion.arn
      id     = ingestion.ingestion_id
      status = ingestion.ingestion_status
      refresh_type = {
        for k, v in local.refresh_types :
        v => k
      }[ingestion.ingestion_type]
    }
  ]
}

output "permissions" {
  description = "The permissions associated with the QuickSight data set."
  value       = aws_quicksight_data_set.this.permissions
}

output "row_level_permission_data_set" {
  description = "The row-level permission data set configuration."
  value       = var.row_level_permission_data_set
}

output "column_level_permission_rules" {
  description = "A list of column-level permission rules."
  value = [
    for rule in aws_quicksight_data_set.this.column_level_permission_rules :
    {
      columns    = rule.column_names
      principals = rule.principals
    }
  ]
}

output "data_set_usage" {
  description = "The usage configuration for the data set."
  value = {
    use_as_direct_query_source = !aws_quicksight_data_set.this.data_set_usage_configuration[0].disable_use_as_direct_query_source
    use_as_imported_source     = !aws_quicksight_data_set.this.data_set_usage_configuration[0].disable_use_as_imported_source
  }
}

output "resource_group" {
  description = "The resource group created to manage resources in this module."
  value = merge(
    {
      enabled = var.resource_group.enabled && var.module_tags_enabled
    },
    (var.resource_group.enabled && var.module_tags_enabled
      ? {
        arn  = module.resource_group[0].arn
        name = module.resource_group[0].name
      }
      : {}
    )
  )
}

# output "debug" {
#   value = {
#     main = {
#       for k, v in aws_quicksight_data_set.this :
#       k => v
#       if !contains(["arn", "name", "data_set_id", "tags", "tags_all", "import_mode", "aws_account_id", "permissions", "data_set_usage_configuration", "id", "output_columns", "column_level_permission_rules", "column_groups", "field_folders", "refresh_properties", "logical_table_map", "region"], k)
#     }
#     # refresh_schedules = {
#     #   for id, schedule in aws_quicksight_refresh_schedule.this :
#     #   id => {
#     #     for k, v in schedule :
#     #     k => v
#     #     if !contains(["schedule_id", "aws_account_id", "arn", "data_set_id", "id", "schedule", "region"], k)
#     #   }
#     # }
#     # refresh_ingestions = {
#     #   for id, ingestion in aws_quicksight_ingestion.this :
#     #   id => {
#     #     for k, v in ingestion :
#     #     k => v
#     #     if !contains(["aws_account_id", "data_set_id", "ingestion_id", "arn", "id", "ingestion_type", "ingestion_status", "region"], k)
#     #   }
#     # }
#   }
# }
