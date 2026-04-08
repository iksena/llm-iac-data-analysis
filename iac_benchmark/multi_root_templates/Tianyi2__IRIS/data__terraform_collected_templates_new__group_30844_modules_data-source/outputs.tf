output "region" {
  description = "The AWS region this module resources resides in."
  value       = aws_quicksight_data_source.this.region
}

output "id" {
  description = "The ID of the QuickSight data source."
  value       = aws_quicksight_data_source.this.data_source_id
}

output "arn" {
  description = "The ARN of the QuickSight data source."
  value       = aws_quicksight_data_source.this.arn
}

output "name" {
  description = "The identifier of the QuickSight data source."
  value       = aws_quicksight_data_source.this.data_source_id
}

output "display_name" {
  description = "The display name of the QuickSight data source."
  value       = aws_quicksight_data_source.this.name
}

output "type" {
  description = "The type of the QuickSight data source."
  value       = aws_quicksight_data_source.this.type
}

output "parameters" {
  description = "The configuration for parameters used to connect to the data source."
  value = (contains(["AURORA_POSTGRESQL", "AURORA", "MYSQL", "ORACLE", "POSTGRESQL", "SQLSERVER", "MARIADB"], var.type)
    ? {
      database = try(
        aws_quicksight_data_source.this.parameters[0].aurora_postgresql[0].database,
        aws_quicksight_data_source.this.parameters[0].aurora[0].database,
        aws_quicksight_data_source.this.parameters[0].mysql[0].database,
        aws_quicksight_data_source.this.parameters[0].oracle[0].database,
        aws_quicksight_data_source.this.parameters[0].postgresql[0].database,
        aws_quicksight_data_source.this.parameters[0].sql_server[0].database,
        aws_quicksight_data_source.this.parameters[0].maria_db[0].database,
      )
      host = try(
        aws_quicksight_data_source.this.parameters[0].aurora_postgresql[0].host,
        aws_quicksight_data_source.this.parameters[0].aurora[0].host,
        aws_quicksight_data_source.this.parameters[0].mysql[0].host,
        aws_quicksight_data_source.this.parameters[0].oracle[0].host,
        aws_quicksight_data_source.this.parameters[0].postgresql[0].host,
        aws_quicksight_data_source.this.parameters[0].sql_server[0].host,
        aws_quicksight_data_source.this.parameters[0].maria_db[0].host,
      )
      port = try(
        aws_quicksight_data_source.this.parameters[0].aurora_postgresql[0].port,
        aws_quicksight_data_source.this.parameters[0].aurora[0].port,
        aws_quicksight_data_source.this.parameters[0].mysql[0].port,
        aws_quicksight_data_source.this.parameters[0].oracle[0].port,
        aws_quicksight_data_source.this.parameters[0].postgresql[0].port,
        aws_quicksight_data_source.this.parameters[0].sql_server[0].port,
        aws_quicksight_data_source.this.parameters[0].maria_db[0].port,
      )
    }
    : var.type == "ATHENA" ? {
      workgroup = aws_quicksight_data_source.this.parameters[0].athena[0].work_group
    }
    : var.type == "S3" ? {
      manifest_file_location = "s3://${aws_quicksight_data_source.this.parameters[0].s3[0].manifest_file_location[0].bucket}/${aws_quicksight_data_source.this.parameters[0].s3[0].manifest_file_location[0].key}"
      iam_role               = aws_quicksight_data_source.this.parameters[0].s3[0].role_arn
    }
    : {}
  )
}

output "credentials" {
  description = "The configuration for credentials used to connect to the data source."
  value = nonsensitive(var.credentials) != null ? {
    type = nonsensitive(var.credentials.type)
    credential_pair = (nonsensitive(var.credentials.type) == "CREDENTIAL_PAIR"
      ? {
        username = nonsensitive(aws_quicksight_data_source.this.credentials[0].credential_pair[0].username)
      }
      : null
    )
    data_source            = nonsensitive(aws_quicksight_data_source.this.credentials[0].copy_source_arn)
    secrets_manager_secret = nonsensitive(aws_quicksight_data_source.this.credentials[0].secret_arn)
  } : null
}

output "vpc_connection" {
  description = <<EOF
  The configuration for VPC connection of the data source.
  EOF
  value = {
    enabled = var.vpc_connection.enabled
    arn     = one(aws_quicksight_data_source.this.vpc_connection_properties[*].vpc_connection_arn)
  }
}

output "ssl" {
  description = <<EOF
  The configuration for SSL (Secure Socket Layer) properties of the data source.
  EOF
  value = {
    enabled = !aws_quicksight_data_source.this.ssl_properties[0].disable_ssl
  }
}

output "connection_string" {
  description = "The connection string for the database (when applicable)."
  value = (
    contains(["AURORA_POSTGRESQL", "AURORA", "MYSQL", "ORACLE", "POSTGRESQL", "SQLSERVER", "MARIADB"], var.type) ?
    "${try(var.parameters.host, "")}:${try(var.parameters.port, "")}/${try(var.parameters.database, "")}" :
    null
  )
}

output "permissions" {
  description = "The permissions associated with the QuickSight data source."
  value       = aws_quicksight_data_source.this.permission
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
#     for k, v in aws_quicksight_data_source.this :
#     k => v
#     if !contains(["aws_account_id", "arn", "id", "name", "data_source_id", "tags", "tags_all", "type", "vpc_connection_properties", "ssl_properties", "parameters", "credentials", "permission", "region"], k)
#   }
# }
