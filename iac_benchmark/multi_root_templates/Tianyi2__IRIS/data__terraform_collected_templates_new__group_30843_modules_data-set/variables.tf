variable "region" {
  description = "(Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region."
  type        = string
  default     = null
  nullable    = true
}

variable "name" {
  description = "(Required) An identifier for the QuickSight data set. This ID is a unique identifier for each AWS Region in an AWS account."
  type        = string
  nullable    = false
}

variable "display_name" {
  description = "(Optional) The display name for the QuickSight data set."
  type        = string
  default     = ""
  nullable    = false
}

variable "import_mode" {
  description = "(Optional) Whether you want to import the data into SPICE. Valid values are `SPICE` and `DIRECT_QUERY`. Defaults to `SPICE`."
  type        = string
  default     = "SPICE"
  nullable    = false

  validation {
    condition     = contains(["SPICE", "DIRECT_QUERY"], var.import_mode)
    error_message = "The import_mode must be either `SPICE` or `DIRECT_QUERY`."
  }
}

variable "physical_tables" {
  description = <<EOF
  (Required) A map of physical table configurations. Each entry represents a physical table with its configuration. Each value of `physical_tables` as defined below.
    (Required) `type` - The type of the physical table. Valid values are `S3`, `RELATIONAL_TABLE`, and `CUSTOM_SQL`.
    (Required) `data_source` - The Amazon Resource Name (ARN) of the data source.
    (Optional) `s3` - The configuration for the S3 source. Only required if `type` is `S3`. `s3` as defined below.
      (Optional) `upload_settings` - The settings for uploading data from S3. `upload_settings` as defined below.
        (Optional) `format` - The format of the data in S3. Valid values are `CSV`, `TSV`, `CLF`, `ELF`, `XLSX`, and `JSON`. Defaults to `CSV`.
        (Optional) `starting_row` - The row number to start reading data from. Defaults to 1.
        (Optional) `header_included` - Whether the first row contains column headers. Defaults to true.
        (Optional) `delimiter` - The delimiter used in the data file. Defaults to a comma (`,`).
        (Optional) `text_qualifier` - The text qualifier used in the data file. Valid values are `DOUBLE_QUOTE`, `SINGLE_QUOTE`. Defaults to `DOUBLE_QUOTE`.
      (Required) `input_columns` - A list of input columns for the S3 source, each with a name and type.
    (Optional) `relational_table` - The configuration for the relational table source. Only required if `type` is `RELATIONAL_TABLE`. `relational_table` as defined below.
      (Optional) `catalog` - The catalog associated with the table.
      (Optional) `schema` - The name of the schema. Only used on certain database engines.
      (Required) `table` - The name of the table.
      (Required) `input_columns` - A list of input columns for the relational table source, each with a name and type.
    (Optional) `custom_sql` - The configuration for the custom SQL source. Only required if `type` is `CUSTOM_SQL`. `custom_sql` as defined below.
      (Required) `name` - A display name for the SQL query result.
      (Required) `sql_query` - The SQL query to execute.
      (Required) `input_columns` - The column schema for the SQL query result set.
  EOF
  type = map(object({
    type        = string
    data_source = string
    s3 = optional(object({
      upload_settings = optional(object({
        format          = optional(string, "CSV")
        starting_row    = optional(number, 1)
        header_included = optional(bool, true)
        delimiter       = optional(string, ",")
        text_qualifier  = optional(string, "DOUBLE_QUOTE")
      }), {})
      input_columns = list(object({
        name = string
        type = string
      }))
    }))
    relational_table = optional(object({
      catalog = optional(string)
      schema  = optional(string)
      table   = string
      input_columns = list(object({
        name = string
        type = string
      }))
    }))
    custom_sql = optional(object({
      name      = string
      sql_query = string
      input_columns = optional(list(object({
        name = string
        type = string
      })), [])
    }))
  }))
  default  = {}
  nullable = false

  validation {
    condition     = length(keys(var.physical_tables)) > 0
    error_message = "At least one physical table must be defined in `physical_tables`."
  }
  validation {
    condition = alltrue([
      for table in var.physical_tables :
      contains(["S3", "RELATIONAL_TABLE", "CUSTOM_SQL"], table.type)
    ])
    error_message = "Valid values for `physical_tables.type` are `S3`, `RELATIONAL_TABLE`, and `CUSTOM_SQL`."
  }
  validation {
    condition = alltrue([
      for table in var.physical_tables :
      table.type != "S3" || (
        table.type == "S3" &&
        length(table.s3.input_columns) > 0
      )
    ])
    error_message = "For `S3` type, at least one column must be defined in `input_columns`."
  }
  validation {
    condition = alltrue([
      for table in var.physical_tables :
      table.type != "S3" || (
        table.type == "S3" &&
        alltrue([
          for column in table.s3.input_columns :
          contains(["STRING", "INTEGER", "DECIMAL", "DATETIME", "BOOLEAN", "BIT", "JSON"], column.type)
        ])
      )
    ])
    error_message = "Valid values for `input_columns.type` in `S3` source table are `STRING`, `INTEGER`, `DECIMAL`, `DATETIME`, `BOOLEAN`, `BIT`, and `JSON`."
  }
  validation {
    condition = alltrue([
      for table in var.physical_tables :
      table.type != "S3" || (
        table.type == "S3" &&
        contains(["CSV", "TSV", "CLF", "ELF", "XLSX", "JSON"], table.s3.upload_settings.format)
      )
    ])
    error_message = "Valid values for `upload_settings.format` in `S3` source table are `CSV`, `TSV`, `CLF`, `ELF`, `XLSX`, and `JSON`."
  }
  validation {
    condition = alltrue([
      for table in var.physical_tables :
      table.type != "S3" || (
        table.type == "S3" &&
        contains(["DOUBLE_QUOTE", "SINGLE_QUOTE"], table.s3.upload_settings.text_qualifier)
      )
    ])
    error_message = "Valid values for `upload_settings.text_qualifier` in `S3` source table are `DOUBLE_QUOTE`, `SINGLE_QUOTE`."
  }
  validation {
    condition = alltrue([
      for table in var.physical_tables :
      table.type != "RELATIONAL_TABLE" || (
        table.type == "RELATIONAL_TABLE" &&
        length(table.relational_table.input_columns) > 0
      )
    ])
    error_message = "For `RELATIONAL_TABLE` type, at least one column must be defined in `input_columns`."
  }
  validation {
    condition = alltrue([
      for table in var.physical_tables :
      table.type != "RELATIONAL_TABLE" || (
        table.type == "RELATIONAL_TABLE" &&
        alltrue([
          for column in table.relational_table.input_columns :
          contains(["STRING", "INTEGER", "DECIMAL", "DATETIME", "BOOLEAN", "BIT", "JSON"], column.type)
        ])
      )
    ])
    error_message = "Valid values for `input_columns.type` in `RELATIONAL_TABLE` source table are `STRING`, `INTEGER`, `DECIMAL`, `DATETIME`, `BOOLEAN`, `BIT`, and `JSON`."
  }
  validation {
    condition = alltrue([
      for table in var.physical_tables :
      table.type != "CUSTOM_SQL" || (
        table.type == "CUSTOM_SQL" &&
        alltrue([
          for column in table.custom_sql.input_columns :
          contains(["STRING", "INTEGER", "DECIMAL", "DATETIME", "BOOLEAN", "BIT", "JSON"], column.type)
        ])
      )
    ])
    error_message = "Valid values for `input_columns.type` in `CUSTOM_SQL` source table are `STRING`, `INTEGER`, `DECIMAL`, `DATETIME`, `BOOLEAN`, `BIT`, and `JSON`."
  }
}

variable "logical_tables" {
  description = <<EOF
  (Optional) A map of logical table configurations. Each entry represents a logical table with its configuration. A logical table is a unit that joins and that data transformations operate on. A logical table has a source, which can be either a physical table or result of a join operation. When a logical table points to a physical table, the logical table acts as a mutable copy of that physical table through transform operations. Each value of `logical_tables` as defined below.
    (Required) `alias` - A display name for the logical table.
    (Required) `source` - The source configuration for the logical table, which can be a physical table or a join instruction. `source` as defined below.
      (Optional) `type` - The type of the source. Valid values are `PHYSICAL_TABLE`, `DATA_SET` and `JOIN`. Defaults to `PHYSICAL_TABLE`.
      (Optional) `physical_table` - The ID of the physical table if the source type is `PHYSICAL_TABLE`.
      (Optional) `data_set` - The ARN of the parent data set if the source type is `DATA_SET`.
      (Optional) `join` - A join instruction if the source type is `JOIN`. `join` as defined below.
        (Required) `left_operand` - The operand on the left side of the join. This can be a logical table id.
        (Required) `right_operand` - The operand on the right side of the join. This can be a logical table id.
        (Required) `type` - The type of the join. Valid values are `INNER`, `LEFT`, `RIGHT`, and `FULL`.
        (Required) `on_clause` - The SQL expression that defines the `ON` clause of the join.
        (Optional) `left_join_key_properties` - Properties for the left join key. `left_join_key_properties` as defined below.
          (Optional) `unique_key` - Whether the left join key is unique. Defaults to `false`.
        (Optional) `right_join_key_properties` - Properties for the right join key. `right_join_key_properties` as defined below.
          (Optional) `unique_key` - Whether the right join key is unique. Defaults to `false`.
    (Optional) `data_transforms` - A list of data transformation operations to apply to the logical table. Each item of `data_transforms` as defined below.
      (Optional) `cast_column_type` - A transformation to cast a column to a new type. `cast_column_type` as defined below.
        (Required) `column` - The name of the column to cast.
        (Required) `new_type` - The new type to cast the column to. Valid values are `STRING`, `INTEGER`, `DECIMAL`, `DATETIME`, `BOOLEAN`, `BIT`, and `JSON`.
        (Optional) `format` - The format string for date when casting a column from string to datetime type, you can supply a string in a format supported by Amazon QuickSight to denote the source data format.
      (Optional) `create_columns` - A transformation to create new calculated columns. Columns created in one such operation form a lexical closure. `create_columns` as defined below.
        (Required) `columns` - A list of calculated columns to create. Each item of `columns` as defined below.
          (Required) `id` - The unique identifier for the calculated column.
          (Required) `name` - The display name for the calculated column.
          (Required) `expression` - An expression that defines the calculated column.
      (Optional) `filter` - A transformation to filter rows based on a condition. `filter` as defined below.
        (Required) `condition` - An expression that must evaluate to true for a row to be included in the logical table.
      (Optional) `project` - A transformation to project specific columns. Operations that come after a projection can only refer to projected columns. `project` as defined below.
        (Required) `columns` - A list of columns to include in the projection.
      (Optional) `rename_column` - A transformation to rename a column. `rename_column` as defined below.
        (Required) `column` - The name of the column to rename.
        (Required) `new_name` - The new name for the column.
      (Optional) `tag_column` - A transformation to tag a column with metadata. `tag_column` as defined below.
        (Required) `column` - The name of the column to tag.
        (Required) `tags` - A list of tags to apply to the column. Currently only used for geospatial type tagging. Each item of `tags` as defined below.
          (Optional) `description` - A description for the tag. Defaults to "Managed by Terraform."
          (Optional) `geographic_role` - The geographic role for the tag. Valid values are `COUNTRY`, `STATE`, `COUNTY`, `CITY`, `POSTCODE`, `LONGITUDE`, and `LATITUDE`.
      (Optional) `untag_column` - A transformation to remove tags from a column. `untag_column` as defined below.
        (Required) `column` - The name of the column from which to remove tags.
        (Required) `tags` - A set of tags to remove from the column.
  EOF
  type = map(object({
    alias = string
    source = object({
      type           = optional(string, "PHYSICAL_TABLE")
      physical_table = optional(string)
      data_set       = optional(string)
      join = optional(object({
        left_operand  = string
        right_operand = string
        type          = string
        on_clause     = string
        left_join_key_properties = optional(object({
          unique_key = optional(bool, false)
        }))
        right_join_key_properties = optional(object({
          unique_key = optional(bool, false)
        }))
      }))
    })
    data_transforms = optional(list(object({
      cast_column_type = optional(object({
        column   = string
        new_type = string
        format   = optional(string)
      }))
      create_columns = optional(object({
        columns = list(object({
          id         = string
          name       = string
          expression = string
        }))
      }))
      filter = optional(object({
        condition = string
      }))
      project = optional(object({
        columns = list(string)
      }))
      rename_column = optional(object({
        column   = string
        new_name = string
      }))
      tag_column = optional(object({
        column = string
        tags = list(object({
          description     = optional(string, "Managed by Terraform.")
          geographic_role = optional(string)
        }))
      }))
      untag_column = optional(object({
        column = string
        tags   = set(string)
      }))
    })), [])
  }))
  default  = {}
  nullable = false

  # validation {
  #   condition     = length(keys(var.logical_tables)) > 0
  #   error_message = "At least one logical table must be defined in `logical_tables`."
  # }
  validation {
    condition = alltrue([
      for table in var.logical_tables :
      contains(["PHYSICAL_TABLE", "DATA_SET", "JOIN"], table.source.type)
    ])
    error_message = "Valid values for `source.type` are `PHYSICAL_TABLE`, `DATA_SET`, and `JOIN`."
  }
  validation {
    condition = alltrue([
      for table in var.logical_tables :
      table.source.type != "PHYSICAL_TABLE" || (
        table.source.type == "PHYSICAL_TABLE" &&
        table.source.physical_table != null
      )
    ])
    error_message = "For `PHYSICAL_TABLE` type, `physical_table` must be specified."
  }
  validation {
    condition = alltrue([
      for table in var.logical_tables :
      table.source.type != "DATA_SET" || (
        table.source.type == "DATA_SET" &&
        table.source.data_set != null
      )
    ])
    error_message = "For `DATA_SET` type, `data_set` must be specified."
  }
  validation {
    condition = alltrue([
      for table in var.logical_tables :
      table.source.type != "JOIN" || (
        table.source.type == "JOIN" &&
        contains(["INNER", "LEFT", "RIGHT", "FULL"], table.source.join.type)
      )
    ])
    error_message = "Valid values for `source.join.type` are `INNER`, `LEFT`, `RIGHT`, and `FULL`."
  }
  validation {
    condition = alltrue([
      for table in var.logical_tables :
      alltrue([
        for transform in table.data_transforms :
        length([for v in values(transform) :
          v
          if v != null
        ]) == 1
      ])
    ])
    error_message = "Only one operation for each `data_transforms` item is allowed."
  }
  validation {
    condition = alltrue([
      for table in var.logical_tables :
      alltrue([
        for transform in table.data_transforms :
        alltrue([
          for tag in transform.tag_column.tags :
          tag.geographic_role == null || contains(["COUNTRY", "STATE", "COUNTY", "CITY", "POSTCODE", "LONGITUDE", "LATITUDE"], tag.geographic_role)
        ])
        if transform.tag_column != null
      ])
    ])
    error_message = "Valid values for `tag_column.tags.geographic_role` are `COUNTRY`, `STATE`, `COUNTY`, `CITY`, `POSTCODE`, `LONGITUDE`, and `LATITUDE`."
  }
}

variable "column_folders" {
  description = <<EOF
  (Optional) A map of column folder configurations. Each entry represents a column folder (field folder) in the data set. A column folder is a logical grouping of columns that can be used to organize and categorize columns within the data set. Each key of `column_folders` is the folder name. `/` is used as a separator for subfolders. The folder name can be used to create a hierarchy of folders. Each value of `column_folders` as defined below.
    (Optional) `columns` - A set of columns that belong to this folder. A column can only belong to one folder.
    (Optional) `description` - A description for the column folder. Defaults to "Managed by Terraform."
  EOF
  type = map(object({
    columns     = optional(set(string), [])
    description = optional(string, "Managed by Terraform.")
  }))
  default  = {}
  nullable = false
}

variable "geo_spatial_column_groups" {
  description = <<EOF
  (Optional) A set of geographic column groups. A geo spatial column group is a logical grouping of two or more columns in the data set that together represent a geographical hierarchy, such as country, state, and city. This configuration allows QuickSight to recognize and use these columns as a spatial hierarchy for advanced geo-mapping and drill-down capabilities in visualizations. Each item of `geo_spatial_column_groups` as defined below.
    (Required) `name` - A display name for the geographical hierarchy.
    (Optional) `country_code` - The country code for the geographic column group. Valid values are ISO 3166-1 alpha-2 country codes like `US`.
    (Required) `columns` - A list of columns that are part of the geographical hierarchy.
  EOF
  type = list(object({
    name         = string
    country_code = optional(string)
    columns      = optional(list(string), [])
  }))
  default  = []
  nullable = false

  validation {
    condition     = length(var.geo_spatial_column_groups) <= 8
    error_message = "Maximum of 8 geo spatial column groups can be defined."
  }
  validation {
    condition = alltrue([
      for group in var.geo_spatial_column_groups :
      length(group.columns) >= 2
    ])
    error_message = "Each geo spatial column group must contain at least two columns."
  }
  validation {
    condition = alltrue([
      for group in var.geo_spatial_column_groups :
      length(group.columns) <= 16
    ])
    error_message = "Each geo spatial column group can contain a maximum of 16 columns."
  }
}

variable "refresh_config" {
  description = <<EOF
  (Optional) A refresh configuration for the  data set. `refresh_config` as defined below.
    (Optional) `incremental_refresh_lookback_window` - The configuration for the incremental refresh lookback window. This is used to determine how far back in time the incremental refresh should look for new or changed data. `incremental_refresh_lookback_window` as defined below.
      (Required) `column` - The column that contains the timestamp or date information to use for the lookback window.
      (Required) `size` - The size of the lookback window.
      (Required) `unit` - The unit of time for the lookback window. Valid values are `HOUR`, `DAY`, and `WEEK`.
  EOF
  type = object({
    incremental_refresh_lookback_window = optional(object({
      column = string
      size   = number
      unit   = string
    }))
  })
  default  = {}
  nullable = false

  validation {
    condition = anytrue([
      var.refresh_config.incremental_refresh_lookback_window == null,
      (
        var.refresh_config.incremental_refresh_lookback_window != null &&
        contains(["HOUR", "DAY", "WEEK"], var.refresh_config.incremental_refresh_lookback_window.unit)
      )
    ])
    error_message = "Valid values for `incremental_refresh_lookback_window.unit` are `HOUR`, `DAY`, and `WEEK`."
  }
}

variable "refresh_schedules" {
  description = <<EOF
  (Optional) A list of refresh schedule configurations. Each item of `refresh_schedules` as defined below.
    (Required) `id` - The unique identifier for the refresh schedule.
    (Optional) `refresh_type` - The type of the refresh schedule. Valid values are `INCREMENTAL` and `FULL`. Defaults to `FULL`.
    (Optional) `start_at` - The date and time after which the refresh schedule can be started, expressed in `YYYY-MM-DDTHH:MM:SS` format.
    (Required) `schedule_frequency` - The configuration for the refresh schedule frequency. `schedule_frequency` as defined below.
      (Optional) `timezone` - The timezone that you want the refresh schedule to use.
      (Optional) `interval` - The interval at which the refresh should occur. Valid values are `MINUTE15`, `MINUTE30`, `HOURLY`, `DAILY`, `WEEKLY`, and `MONTHLY`. Defaults to `DAILY`.
        - `MINUTE15` : The dataset refreshes every 15 minutes. This value is only supported for incremental refreshes. This interval can only be used for one schedule per dataset.
        - `MINUTE30` : The dataset refreshes every 30 minutes. This value is only supported for incremental refreshes. This interval can only be used for one schedule per dataset.
        - `HOURLY` : The dataset refreshes every hour. This interval can only be used for one schedule per dataset.
        - `DAILY` : The dataset refreshes every day.
        - `WEEKLY` : The dataset refreshes every week.
        - `MONTHLY` : The dataset refreshes every month.
      (Optional) `time_of_day` - The time of day that you want the dataset to refresh. This value is expressed in `HH:MM` format. This field is not required for schedules with `HOURLY` refresh type. Defaults to `00:00` (midnight).
      (Optional) `day_of_week` - The day of the week on which the refresh should occur. Valid values are `SUNDAY`, `MONDAY`, `TUESDAY`, `WEDNESDAY`, `THURSDAY`, `FRIDAY`, and `SATURDAY`. Required if `interval` is set to `WEEKLY`.
      (Optional) `day_of_month` - The day of the month on which the refresh should occur. Valid values are `1` to `28`, and `LAST_DAY_OF_MONTH`. Required if `interval` is set to `MONTHLY`.
  EOF
  type = list(object({
    id           = string
    refresh_type = optional(string, "FULL")
    start_at     = optional(string)
    schedule_frequency = object({
      timezone     = optional(string)
      interval     = optional(string, "DAILY")
      time_of_day  = optional(string, "00:00")
      day_of_week  = optional(string)
      day_of_month = optional(string)
    })
  }))
  default  = []
  nullable = false

  validation {
    condition     = length(var.refresh_schedules) <= 5
    error_message = "Maximum of 5 refresh schedules can be specified."
  }
  validation {
    condition = alltrue([
      for schedule in var.refresh_schedules :
      contains(["INCREMENTAL", "FULL"], schedule.refresh_type)
    ])
    error_message = "Valid values for `refresh_type` are `INCREMENTAL` and `FULL`."
  }
  validation {
    condition = alltrue([
      for schedule in var.refresh_schedules :
      contains(["MINUTE15", "MINUTE30", "HOURLY", "DAILY", "WEEKLY", "MONTHLY"], schedule.schedule_frequency.interval)
    ])
    error_message = "Valid values for `schedule_frequency.interval` are `MINUTE15`, `MINUTE30`, `HOURLY`, `DAILY`, `WEEKLY`, and `MONTHLY`."
  }
  validation {
    condition = alltrue([
      for schedule in var.refresh_schedules :
      anytrue([
        !contains(["MINUTE15", "MINUTE30"], schedule.schedule_frequency.interval),
        contains(["MINUTE15", "MINUTE30"], schedule.schedule_frequency.interval) && schedule.refresh_type == "INCREMENTAL"
      ])
    ])
    error_message = "`MINUTE15` and `MINUTE30` intervals are only supported for `INCREMENTAL` refresh schedules."
  }
}

variable "refresh_ingestions" {
  description = <<EOF
  (Optional) A list of refresh ingestion configurations. Each item of `refresh_ingestions` as defined below.
    (Required) `id` - The unique identifier for the refresh ingestion.
    (Optional) `refresh_type` - The type of the refresh ingestion. Valid values are `INCREMENTAL` and `FULL`. Defaults to `FULL`.
  EOF
  type = list(object({
    id           = string
    refresh_type = optional(string, "FULL")
  }))
  default  = []
  nullable = false

  validation {
    condition = alltrue([
      for ingestion in var.refresh_ingestions :
      contains(["INCREMENTAL", "FULL"], ingestion.refresh_type)
    ])
    error_message = "Valid values for `refresh_type` are `INCREMENTAL` and `FULL`."
  }
}

variable "permissions" {
  description = <<EOF
  (Optional) A list of resource permissions on the data set. Each item of `permissions` as defined below.
    (Required) `principal` - The Amazon Resource Name (ARN) of the principal. This can be one of the following:
      - The ARN of an Amazon QuickSight user or group associated with a data source or dataset. (This is common.)
      - The ARN of an Amazon QuickSight user, group, or namespace associated with an analysis, dashboard, template, or theme. (This is common.)
      - The ARN of an Amazon Web Services account root: This is an IAM ARN rather than a QuickSight ARN. Use this option only to share resources (templates) across Amazon Web Services accounts. (This is less common.)
    (Optional) `role` - A role of principal with a pre-defined set of permissions. Valid values are `OWNER` and `USER`. Conflicting with `actions`.
    (Optional) `actions` - A set of IAM actions to grant or revoke permissions on. Conflicting with `role`.
  EOF
  type = list(object({
    principal = string
    role      = optional(string)
    actions   = optional(set(string), [])
  }))
  default  = []
  nullable = false

  validation {
    condition = alltrue([
      for permission in var.permissions :
      contains(["OWNER", "USER"], permission.role) || length(permission.actions) > 0
    ])
    error_message = "Valid values for `permission.role` are `OWNER` and `USER`. If `role` is not set, then `actions` must be specified."
  }
}

variable "row_level_permission_data_set" {
  description = "(Optional) Configuration for row-level permission data set."
  type = object({
    arn               = string
    permission_policy = string
    format_version    = optional(string)
    namespace         = optional(string)
    status            = optional(string)
  })
  default = null
}

variable "column_level_permission_rules" {
  description = <<EOF
  (Optional) A list of column-level permission rules. To create a restricted column, you add it to one or more rules. Each rule must contain at least one column and at least one user or group. To be able to see a restricted column, a user or group needs to be added to a rule for that column. Each rule specifies which columns are accessible to which principals. Each item of `column_level_permission_rules` as defined below.
    (Required) `columns` - A set of column names that the rule applies to. At least one column must be specified.
    (Required) `principals` - A set of ARNs (Amazon Resource Names) of the principals (users or groups) that this rule applies to. At least one principal must be specified. Maximum of 100 items.
  EOF
  type = list(object({
    columns    = optional(set(string), [])
    principals = optional(set(string), [])
  }))
  default  = []
  nullable = false

  validation {
    condition = alltrue([
      for rule in var.column_level_permission_rules :
      length(rule.columns) > 0 && length(rule.principals) > 0
    ])
    error_message = "Each column-level permission rule must specify at least one column and at least one principal."
  }
  validation {
    condition = alltrue([
      for rule in var.column_level_permission_rules :
      length(rule.principals) <= 100
    ])
    error_message = "Maximum of 100 principals can be specified per column-level permission rule."
  }
}

variable "data_set_usage" {
  description = <<EOF
  (Optional) The usage configuration to apply to child datasets that reference this dataset as a source. `data_set_usage` as defined below.
    (Optional) `use_as_direct_query_source` - Whether to enable the use of this data set as a direct query source. Defaults to `true`.
    (Optional) `use_as_imported_source` - Whether to enable the use of this data set as an imported source. Defaults to `true`.
  EOF
  type = object({
    use_as_direct_query_source = optional(bool, true)
    use_as_imported_source     = optional(bool, true)
  })
  default  = {}
  nullable = false
}

variable "tags" {
  description = "(Optional) A map of tags to add to all resources."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "module_tags_enabled" {
  description = "(Optional) Whether to create AWS Resource Tags for the module informations."
  type        = bool
  default     = true
  nullable    = false
}


###################################################
# Resource Group
###################################################

variable "resource_group" {
  description = <<EOF
  (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.
    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.
    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.
    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`.
  EOF
  type = object({
    enabled     = optional(bool, true)
    name        = optional(string, "")
    description = optional(string, "Managed by Terraform.")
  })
  default  = {}
  nullable = false
}
