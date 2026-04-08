variable "data_set_id" {
  description = "Identifier for the data set"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.data_set_id))
    error_message = "resource_aws_quicksight_data_set, data_set_id must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "import_mode" {
  description = "Indicates whether you want to import the data into SPICE. Valid values are SPICE and DIRECT_QUERY"
  type        = string

  validation {
    condition     = contains(["SPICE", "DIRECT_QUERY"], var.import_mode)
    error_message = "resource_aws_quicksight_data_set, import_mode must be either SPICE or DIRECT_QUERY."
  }
}

variable "name" {
  description = "Display name for the dataset"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_quicksight_data_set, name cannot be empty."
  }
}

variable "aws_account_id" {
  description = "AWS account ID. Defaults to automatically determined account ID of the Terraform AWS provider"
  type        = string
  default     = null

  validation {
    condition     = var.aws_account_id == null || can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "resource_aws_quicksight_data_set, aws_account_id must be a 12-digit AWS account ID."
  }
}

variable "column_groups" {
  description = "Groupings of columns that work together in certain Amazon QuickSight features"
  type = list(object({
    geo_spatial_column_group = optional(object({
      columns      = list(string)
      country_code = string
      name         = string
    }))
  }))
  default = []

  validation {
    condition = alltrue([
      for cg in var.column_groups :
      cg.geo_spatial_column_group == null || contains(["US"], cg.geo_spatial_column_group.country_code)
    ])
    error_message = "resource_aws_quicksight_data_set, column_groups geo_spatial_column_group country_code must be US."
  }

  validation {
    condition = alltrue([
      for cg in var.column_groups :
      cg.geo_spatial_column_group == null || length(cg.geo_spatial_column_group.columns) > 0
    ])
    error_message = "resource_aws_quicksight_data_set, column_groups geo_spatial_column_group columns cannot be empty."
  }

  validation {
    condition = alltrue([
      for cg in var.column_groups :
      cg.geo_spatial_column_group == null || length(cg.geo_spatial_column_group.name) > 0
    ])
    error_message = "resource_aws_quicksight_data_set, column_groups geo_spatial_column_group name cannot be empty."
  }
}

variable "column_level_permission_rules" {
  description = "A set of 1 or more definitions of a ColumnLevelPermissionRule"
  type = list(object({
    column_names = optional(list(string))
    principals   = optional(list(string))
  }))
  default = []
}

variable "data_set_usage_configuration" {
  description = "The usage configuration to apply to child datasets that reference this dataset as a source"
  type = object({
    disable_use_as_direct_query_source = optional(bool)
    disable_use_as_imported_source     = optional(bool)
  })
  default = null
}

variable "field_folders" {
  description = "The folder that contains fields and nested subfolders for your dataset"
  type = list(object({
    field_folders_id = string
    columns          = optional(list(string))
    description      = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for ff in var.field_folders : length(ff.field_folders_id) > 0
    ])
    error_message = "resource_aws_quicksight_data_set, field_folders field_folders_id cannot be empty."
  }
}

variable "logical_table_map" {
  description = "Configures the combination and transformation of the data from the physical tables"
  type = object({
    alias                = string
    logical_table_map_id = string
    data_transforms = optional(list(object({
      cast_column_type_operation = optional(object({
        column_name     = string
        new_column_type = string
        format          = optional(string)
      }))
      create_columns_operation = optional(object({
        columns = list(object({
          column_id   = string
          column_name = string
          expression  = string
        }))
      }))
      filter_operation = optional(object({
        condition_expression = string
      }))
      project_operation = optional(object({
        projected_columns = list(string)
      }))
      rename_column_operation = optional(object({
        column_name     = string
        new_column_name = string
      }))
      tag_column_operation = optional(object({
        column_name = string
        tags = optional(object({
          column_description = optional(object({
            text = optional(string)
          }))
          column_geographic_role = optional(string)
        }))
      }))
      untag_column_operation = optional(object({
        column_name = string
        tag_names   = list(string)
      }))
    })))
    source = optional(object({
      data_set_arn      = optional(string)
      physical_table_id = optional(string)
      join_instruction = optional(object({
        left_operand  = string
        on_clause     = string
        right_operand = string
        type          = string
        left_join_key_properties = optional(object({
          unique_key = optional(bool)
        }))
        right_join_key_properties = optional(object({
          unique_key = optional(bool)
        }))
      }))
    }))
  })
  default = null

  validation {
    condition     = var.logical_table_map == null || length(var.logical_table_map.alias) > 0
    error_message = "resource_aws_quicksight_data_set, logical_table_map alias cannot be empty."
  }

  validation {
    condition     = var.logical_table_map == null || length(var.logical_table_map.logical_table_map_id) > 0
    error_message = "resource_aws_quicksight_data_set, logical_table_map logical_table_map_id cannot be empty."
  }

  validation {
    condition = var.logical_table_map == null || var.logical_table_map.data_transforms == null || alltrue([
      for dt in var.logical_table_map.data_transforms :
      dt.cast_column_type_operation == null || contains(["STRING", "INTEGER", "DECIMAL", "DATETIME"], dt.cast_column_type_operation.new_column_type)
    ])
    error_message = "resource_aws_quicksight_data_set, logical_table_map data_transforms cast_column_type_operation new_column_type must be one of STRING, INTEGER, DECIMAL, DATETIME."
  }

  validation {
    condition = var.logical_table_map == null || var.logical_table_map.data_transforms == null || alltrue([
      for dt in var.logical_table_map.data_transforms :
      dt.tag_column_operation == null || dt.tag_column_operation.tags == null || dt.tag_column_operation.tags.column_geographic_role == null || contains(["COUNTRY", "STATE", "COUNTY", "CITY", "POSTCODE", "LONGITUDE", "LATITUDE"], dt.tag_column_operation.tags.column_geographic_role)
    ])
    error_message = "resource_aws_quicksight_data_set, logical_table_map data_transforms tag_column_operation tags column_geographic_role must be one of COUNTRY, STATE, COUNTY, CITY, POSTCODE, LONGITUDE, LATITUDE."
  }

  validation {
    condition     = var.logical_table_map == null || var.logical_table_map.source == null || var.logical_table_map.source.join_instruction == null || contains(["INNER", "OUTER", "LEFT", "RIGHT"], var.logical_table_map.source.join_instruction.type)
    error_message = "resource_aws_quicksight_data_set, logical_table_map source join_instruction type must be one of INNER, OUTER, LEFT, RIGHT."
  }
}

variable "permissions" {
  description = "A set of resource permissions on the data source. Maximum of 64 items"
  type = list(object({
    actions   = list(string)
    principal = string
  }))
  default = []

  validation {
    condition     = length(var.permissions) <= 64
    error_message = "resource_aws_quicksight_data_set, permissions cannot exceed 64 items."
  }

  validation {
    condition = alltrue([
      for p in var.permissions : length(p.actions) > 0
    ])
    error_message = "resource_aws_quicksight_data_set, permissions actions cannot be empty."
  }

  validation {
    condition = alltrue([
      for p in var.permissions : length(p.principal) > 0
    ])
    error_message = "resource_aws_quicksight_data_set, permissions principal cannot be empty."
  }
}

variable "physical_table_map" {
  description = "Declares the physical tables that are available in the underlying data sources"
  type = list(object({
    physical_table_map_id = string
    custom_sql = optional(object({
      data_source_arn = string
      name            = string
      sql_query       = string
      columns = optional(list(object({
        name = string
        type = string
      })))
    }))
    relational_table = optional(object({
      data_source_arn = string
      name            = string
      input_columns = list(object({
        name = string
        type = string
      }))
      catalog = optional(string)
      schema  = optional(string)
    }))
    s3_source = optional(object({
      data_source_arn = string
      input_columns = list(object({
        name = string
        type = string
      }))
      upload_settings = optional(object({
        contains_header = optional(bool)
        delimiter       = optional(string)
        format          = optional(string)
        start_from_row  = optional(number)
        text_qualifier  = optional(string)
      }))
    }))
  }))
  default = []

  validation {
    condition = alltrue([
      for ptm in var.physical_table_map : length(ptm.physical_table_map_id) > 0
    ])
    error_message = "resource_aws_quicksight_data_set, physical_table_map physical_table_map_id cannot be empty."
  }

  validation {
    condition = alltrue([
      for ptm in var.physical_table_map :
      sum([
        ptm.custom_sql != null ? 1 : 0,
        ptm.relational_table != null ? 1 : 0,
        ptm.s3_source != null ? 1 : 0
      ]) == 1
    ])
    error_message = "resource_aws_quicksight_data_set, physical_table_map must have exactly one of custom_sql, relational_table, or s3_source configured."
  }

  validation {
    condition = alltrue([
      for ptm in var.physical_table_map :
      ptm.custom_sql == null || length(ptm.custom_sql.data_source_arn) > 0
    ])
    error_message = "resource_aws_quicksight_data_set, physical_table_map custom_sql data_source_arn cannot be empty."
  }

  validation {
    condition = alltrue([
      for ptm in var.physical_table_map :
      ptm.custom_sql == null || length(ptm.custom_sql.name) > 0
    ])
    error_message = "resource_aws_quicksight_data_set, physical_table_map custom_sql name cannot be empty."
  }

  validation {
    condition = alltrue([
      for ptm in var.physical_table_map :
      ptm.custom_sql == null || length(ptm.custom_sql.sql_query) > 0
    ])
    error_message = "resource_aws_quicksight_data_set, physical_table_map custom_sql sql_query cannot be empty."
  }

  validation {
    condition = alltrue([
      for ptm in var.physical_table_map :
      ptm.relational_table == null || length(ptm.relational_table.data_source_arn) > 0
    ])
    error_message = "resource_aws_quicksight_data_set, physical_table_map relational_table data_source_arn cannot be empty."
  }

  validation {
    condition = alltrue([
      for ptm in var.physical_table_map :
      ptm.relational_table == null || length(ptm.relational_table.name) > 0
    ])
    error_message = "resource_aws_quicksight_data_set, physical_table_map relational_table name cannot be empty."
  }

  validation {
    condition = alltrue([
      for ptm in var.physical_table_map :
      ptm.relational_table == null || length(ptm.relational_table.input_columns) > 0
    ])
    error_message = "resource_aws_quicksight_data_set, physical_table_map relational_table input_columns cannot be empty."
  }

  validation {
    condition = alltrue([
      for ptm in var.physical_table_map :
      ptm.s3_source == null || length(ptm.s3_source.data_source_arn) > 0
    ])
    error_message = "resource_aws_quicksight_data_set, physical_table_map s3_source data_source_arn cannot be empty."
  }

  validation {
    condition = alltrue([
      for ptm in var.physical_table_map :
      ptm.s3_source == null || length(ptm.s3_source.input_columns) > 0
    ])
    error_message = "resource_aws_quicksight_data_set, physical_table_map s3_source input_columns cannot be empty."
  }

  validation {
    condition = alltrue([
      for ptm in var.physical_table_map :
      ptm.s3_source == null || ptm.s3_source.upload_settings == null || ptm.s3_source.upload_settings.format == null || contains(["CSV", "TSV", "CLF", "ELF", "XLSX", "JSON"], ptm.s3_source.upload_settings.format)
    ])
    error_message = "resource_aws_quicksight_data_set, physical_table_map s3_source upload_settings format must be one of CSV, TSV, CLF, ELF, XLSX, JSON."
  }

  validation {
    condition = alltrue([
      for ptm in var.physical_table_map :
      ptm.s3_source == null || ptm.s3_source.upload_settings == null || ptm.s3_source.upload_settings.text_qualifier == null || contains(["DOUBLE_QUOTE", "SINGLE_QUOTE"], ptm.s3_source.upload_settings.text_qualifier)
    ])
    error_message = "resource_aws_quicksight_data_set, physical_table_map s3_source upload_settings text_qualifier must be one of DOUBLE_QUOTE, SINGLE_QUOTE."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "row_level_permission_data_set" {
  description = "The row-level security configuration for the data that you want to create"
  type = object({
    arn               = string
    permission_policy = string
    format_version    = optional(string)
    namespace         = optional(string)
    status            = optional(string)
  })
  default = null

  validation {
    condition     = var.row_level_permission_data_set == null || length(var.row_level_permission_data_set.arn) > 0
    error_message = "resource_aws_quicksight_data_set, row_level_permission_data_set arn cannot be empty."
  }

  validation {
    condition     = var.row_level_permission_data_set == null || contains(["GRANT_ACCESS", "DENY_ACCESS"], var.row_level_permission_data_set.permission_policy)
    error_message = "resource_aws_quicksight_data_set, row_level_permission_data_set permission_policy must be either GRANT_ACCESS or DENY_ACCESS."
  }

  validation {
    condition     = var.row_level_permission_data_set == null || var.row_level_permission_data_set.status == null || contains(["ENABLED", "DISABLED"], var.row_level_permission_data_set.status)
    error_message = "resource_aws_quicksight_data_set, row_level_permission_data_set status must be either ENABLED or DISABLED."
  }
}

variable "row_level_permission_tag_configuration" {
  description = "The configuration of tags on a dataset to set row-level security"
  type = object({
    status = optional(string)
    tag_rules = list(object({
      column_name               = string
      tag_key                   = string
      match_all_value           = optional(string)
      tag_multi_value_delimiter = optional(string)
    }))
  })
  default = null

  validation {
    condition     = var.row_level_permission_tag_configuration == null || var.row_level_permission_tag_configuration.status == null || contains(["ENABLED", "DISABLED"], var.row_level_permission_tag_configuration.status)
    error_message = "resource_aws_quicksight_data_set, row_level_permission_tag_configuration status must be either ENABLED or DISABLED."
  }

  validation {
    condition = var.row_level_permission_tag_configuration == null || alltrue([
      for tr in var.row_level_permission_tag_configuration.tag_rules : length(tr.column_name) > 0
    ])
    error_message = "resource_aws_quicksight_data_set, row_level_permission_tag_configuration tag_rules column_name cannot be empty."
  }

  validation {
    condition = var.row_level_permission_tag_configuration == null || alltrue([
      for tr in var.row_level_permission_tag_configuration.tag_rules : length(tr.tag_key) > 0
    ])
    error_message = "resource_aws_quicksight_data_set, row_level_permission_tag_configuration tag_rules tag_key cannot be empty."
  }
}

variable "refresh_properties" {
  description = "The refresh properties for the data set"
  type = object({
    refresh_configuration = object({
      incremental_refresh = object({
        lookback_window = object({
          column_name = string
          size        = number
          size_unit   = string
        })
      })
    })
  })
  default = null

  validation {
    condition     = var.refresh_properties == null || length(var.refresh_properties.refresh_configuration.incremental_refresh.lookback_window.column_name) > 0
    error_message = "resource_aws_quicksight_data_set, refresh_properties refresh_configuration incremental_refresh lookback_window column_name cannot be empty."
  }

  validation {
    condition     = var.refresh_properties == null || var.refresh_properties.refresh_configuration.incremental_refresh.lookback_window.size > 0
    error_message = "resource_aws_quicksight_data_set, refresh_properties refresh_configuration incremental_refresh lookback_window size must be greater than 0."
  }

  validation {
    condition     = var.refresh_properties == null || contains(["HOUR", "DAY", "WEEK"], var.refresh_properties.refresh_configuration.incremental_refresh.lookback_window.size_unit)
    error_message = "resource_aws_quicksight_data_set, refresh_properties refresh_configuration incremental_refresh lookback_window size_unit must be one of HOUR, DAY, WEEK."
  }
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}