variable "data_source_id" {
  description = "An identifier for the data source"
  type        = string

  validation {
    condition     = length(var.data_source_id) > 0
    error_message = "resource_aws_quicksight_data_source, data_source_id must be a non-empty string."
  }
}

variable "name" {
  description = "A name for the data source, maximum of 128 characters"
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 128
    error_message = "resource_aws_quicksight_data_source, name must be between 1 and 128 characters."
  }
}

variable "parameters" {
  description = "The parameters used to connect to this data source"
  type = object({
    amazon_elasticsearch = optional(object({
      domain = string
    }))
    athena = optional(object({
      work_group = optional(string)
    }))
    aurora = optional(object({
      database = string
      host     = string
      port     = number
    }))
    aurora_postgresql = optional(object({
      database = string
      host     = string
      port     = number
    }))
    aws_iot_analytics = optional(object({
      data_set_name = string
    }))
    databricks = optional(object({
      host              = string
      port              = number
      sql_endpoint_path = string
    }))
    jira = optional(object({
      site_base_url = string
    }))
    maria_db = optional(object({
      database = string
      host     = string
      port     = number
    }))
    mysql = optional(object({
      database = string
      host     = string
      port     = number
    }))
    oracle = optional(object({
      database = string
      host     = string
      port     = number
    }))
    postgresql = optional(object({
      database = string
      host     = string
      port     = number
    }))
    presto = optional(object({
      catalog = string
      host    = string
      port    = number
    }))
    rds = optional(object({
      database    = string
      instance_id = optional(string)
    }))
    redshift = optional(object({
      cluster_id = optional(string)
      database   = string
      host       = optional(string)
      port       = optional(number)
    }))
    s3 = optional(object({
      manifest_file_location = object({
        bucket = string
        key    = string
      })
      role_arn = optional(string)
    }))
    service_now = optional(object({
      site_base_url = string
    }))
    snowflake = optional(object({
      database  = string
      host      = string
      warehouse = string
    }))
    spark = optional(object({
      host = string
      port = number
    }))
    sql_server = optional(object({
      database = string
      host     = string
      port     = number
    }))
    teradata = optional(object({
      database = string
      host     = string
      port     = number
    }))
    twitter = optional(object({
      max_rows = number
      query    = string
    }))
  })

  validation {
    condition = sum([
      var.parameters.amazon_elasticsearch != null ? 1 : 0,
      var.parameters.athena != null ? 1 : 0,
      var.parameters.aurora != null ? 1 : 0,
      var.parameters.aurora_postgresql != null ? 1 : 0,
      var.parameters.aws_iot_analytics != null ? 1 : 0,
      var.parameters.databricks != null ? 1 : 0,
      var.parameters.jira != null ? 1 : 0,
      var.parameters.maria_db != null ? 1 : 0,
      var.parameters.mysql != null ? 1 : 0,
      var.parameters.oracle != null ? 1 : 0,
      var.parameters.postgresql != null ? 1 : 0,
      var.parameters.presto != null ? 1 : 0,
      var.parameters.rds != null ? 1 : 0,
      var.parameters.redshift != null ? 1 : 0,
      var.parameters.s3 != null ? 1 : 0,
      var.parameters.service_now != null ? 1 : 0,
      var.parameters.snowflake != null ? 1 : 0,
      var.parameters.spark != null ? 1 : 0,
      var.parameters.sql_server != null ? 1 : 0,
      var.parameters.teradata != null ? 1 : 0,
      var.parameters.twitter != null ? 1 : 0
    ]) == 1
    error_message = "resource_aws_quicksight_data_source, parameters must contain exactly one data source configuration."
  }

  validation {
    condition = var.parameters.redshift != null ? (
      (var.parameters.redshift.cluster_id != null) ||
      (var.parameters.redshift.host != null && var.parameters.redshift.port != null)
    ) : true
    error_message = "resource_aws_quicksight_data_source, redshift parameters must provide either cluster_id or both host and port."
  }
}

variable "type" {
  description = "The type of the data source"
  type        = string

  validation {
    condition = contains([
      "ADOBE_ANALYTICS", "AMAZON_ELASTICSEARCH", "ATHENA", "AURORA", "AURORA_POSTGRESQL",
      "AWS_IOT_ANALYTICS", "DATABRICKS", "GITHUB", "JIRA", "MARIADB", "MYSQL", "ORACLE",
      "POSTGRESQL", "PRESTO", "REDSHIFT", "S3", "SALESFORCE", "SERVICENOW", "SNOWFLAKE",
      "SPARK", "SQLSERVER", "TERADATA", "TIMESTREAM", "TWITTER"
    ], var.type)
    error_message = "resource_aws_quicksight_data_source, type must be a valid data source type."
  }
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
  default     = null

  validation {
    condition     = var.aws_account_id == null || can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "resource_aws_quicksight_data_source, aws_account_id must be a 12-digit number when provided."
  }
}

variable "credentials" {
  description = "The credentials Amazon QuickSight uses to connect to your underlying source"
  type = object({
    copy_source_arn = optional(string)
    credential_pair = optional(object({
      username = string
      password = string
    }))
    secret_arn = optional(string)
  })
  default   = null
  sensitive = true

  validation {
    condition = var.credentials == null || sum([
      var.credentials.copy_source_arn != null ? 1 : 0,
      var.credentials.credential_pair != null ? 1 : 0,
      var.credentials.secret_arn != null ? 1 : 0
    ]) == 1
    error_message = "resource_aws_quicksight_data_source, credentials must contain exactly one authentication method."
  }

  validation {
    condition = var.credentials == null || var.credentials.credential_pair == null || (
      length(var.credentials.credential_pair.username) <= 64 &&
      length(var.credentials.credential_pair.password) <= 1024
    )
    error_message = "resource_aws_quicksight_data_source, credential_pair username must be <= 64 characters and password <= 1024 characters."
  }
}

variable "permission" {
  description = "A set of resource permissions on the data source"
  type = list(object({
    actions   = list(string)
    principal = string
  }))
  default = null

  validation {
    condition     = var.permission == null || length(var.permission) <= 64
    error_message = "resource_aws_quicksight_data_source, permission list cannot exceed 64 items."
  }

  validation {
    condition = var.permission == null || alltrue([
      for perm in var.permission : length(perm.actions) <= 16
    ])
    error_message = "resource_aws_quicksight_data_source, permission actions cannot exceed 16 items per permission."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "ssl_properties" {
  description = "Secure Socket Layer (SSL) properties that apply when Amazon QuickSight connects to your underlying source"
  type = object({
    disable_ssl = bool
  })
  default = null
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}

variable "vpc_connection_properties" {
  description = "Use this parameter only when you want Amazon QuickSight to use a VPC connection when connecting to your underlying source"
  type = object({
    vpc_connection_arn = string
  })
  default = null
}