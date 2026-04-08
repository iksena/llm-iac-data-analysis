resource "aws_quicksight_data_source" "this" {
  aws_account_id = var.aws_account_id
  data_source_id = var.data_source_id
  name           = var.name
  region         = var.region
  type           = var.type
  tags           = var.tags

  dynamic "credentials" {
    for_each = var.credentials != null ? [var.credentials] : []
    content {
      copy_source_arn = credentials.value.copy_source_arn
      secret_arn      = credentials.value.secret_arn

      dynamic "credential_pair" {
        for_each = credentials.value.credential_pair != null ? [credentials.value.credential_pair] : []
        content {
          username = credential_pair.value.username
          password = credential_pair.value.password
        }
      }
    }
  }

  parameters {
    dynamic "amazon_elasticsearch" {
      for_each = var.parameters.amazon_elasticsearch != null ? [var.parameters.amazon_elasticsearch] : []
      content {
        domain = amazon_elasticsearch.value.domain
      }
    }

    dynamic "athena" {
      for_each = var.parameters.athena != null ? [var.parameters.athena] : []
      content {
        work_group = athena.value.work_group
      }
    }

    dynamic "aurora" {
      for_each = var.parameters.aurora != null ? [var.parameters.aurora] : []
      content {
        database = aurora.value.database
        host     = aurora.value.host
        port     = aurora.value.port
      }
    }

    dynamic "aurora_postgresql" {
      for_each = var.parameters.aurora_postgresql != null ? [var.parameters.aurora_postgresql] : []
      content {
        database = aurora_postgresql.value.database
        host     = aurora_postgresql.value.host
        port     = aurora_postgresql.value.port
      }
    }

    dynamic "aws_iot_analytics" {
      for_each = var.parameters.aws_iot_analytics != null ? [var.parameters.aws_iot_analytics] : []
      content {
        data_set_name = aws_iot_analytics.value.data_set_name
      }
    }

    dynamic "databricks" {
      for_each = var.parameters.databricks != null ? [var.parameters.databricks] : []
      content {
        host              = databricks.value.host
        port              = databricks.value.port
        sql_endpoint_path = databricks.value.sql_endpoint_path
      }
    }

    dynamic "jira" {
      for_each = var.parameters.jira != null ? [var.parameters.jira] : []
      content {
        site_base_url = jira.value.site_base_url
      }
    }

    dynamic "maria_db" {
      for_each = var.parameters.maria_db != null ? [var.parameters.maria_db] : []
      content {
        database = maria_db.value.database
        host     = maria_db.value.host
        port     = maria_db.value.port
      }
    }

    dynamic "mysql" {
      for_each = var.parameters.mysql != null ? [var.parameters.mysql] : []
      content {
        database = mysql.value.database
        host     = mysql.value.host
        port     = mysql.value.port
      }
    }

    dynamic "oracle" {
      for_each = var.parameters.oracle != null ? [var.parameters.oracle] : []
      content {
        database = oracle.value.database
        host     = oracle.value.host
        port     = oracle.value.port
      }
    }

    dynamic "postgresql" {
      for_each = var.parameters.postgresql != null ? [var.parameters.postgresql] : []
      content {
        database = postgresql.value.database
        host     = postgresql.value.host
        port     = postgresql.value.port
      }
    }

    dynamic "presto" {
      for_each = var.parameters.presto != null ? [var.parameters.presto] : []
      content {
        catalog = presto.value.catalog
        host    = presto.value.host
        port    = presto.value.port
      }
    }

    dynamic "rds" {
      for_each = var.parameters.rds != null ? [var.parameters.rds] : []
      content {
        database    = rds.value.database
        instance_id = rds.value.instance_id
      }
    }

    dynamic "redshift" {
      for_each = var.parameters.redshift != null ? [var.parameters.redshift] : []
      content {
        cluster_id = redshift.value.cluster_id
        database   = redshift.value.database
        host       = redshift.value.host
        port       = redshift.value.port
      }
    }

    dynamic "s3" {
      for_each = var.parameters.s3 != null ? [var.parameters.s3] : []
      content {
        role_arn = s3.value.role_arn

        manifest_file_location {
          bucket = s3.value.manifest_file_location.bucket
          key    = s3.value.manifest_file_location.key
        }
      }
    }

    dynamic "service_now" {
      for_each = var.parameters.service_now != null ? [var.parameters.service_now] : []
      content {
        site_base_url = service_now.value.site_base_url
      }
    }

    dynamic "snowflake" {
      for_each = var.parameters.snowflake != null ? [var.parameters.snowflake] : []
      content {
        database  = snowflake.value.database
        host      = snowflake.value.host
        warehouse = snowflake.value.warehouse
      }
    }

    dynamic "spark" {
      for_each = var.parameters.spark != null ? [var.parameters.spark] : []
      content {
        host = spark.value.host
        port = spark.value.port
      }
    }

    dynamic "sql_server" {
      for_each = var.parameters.sql_server != null ? [var.parameters.sql_server] : []
      content {
        database = sql_server.value.database
        host     = sql_server.value.host
        port     = sql_server.value.port
      }
    }

    dynamic "teradata" {
      for_each = var.parameters.teradata != null ? [var.parameters.teradata] : []
      content {
        database = teradata.value.database
        host     = teradata.value.host
        port     = teradata.value.port
      }
    }

    dynamic "twitter" {
      for_each = var.parameters.twitter != null ? [var.parameters.twitter] : []
      content {
        max_rows = twitter.value.max_rows
        query    = twitter.value.query
      }
    }
  }

  dynamic "permission" {
    for_each = var.permission != null ? var.permission : []
    content {
      actions   = permission.value.actions
      principal = permission.value.principal
    }
  }

  dynamic "ssl_properties" {
    for_each = var.ssl_properties != null ? [var.ssl_properties] : []
    content {
      disable_ssl = ssl_properties.value.disable_ssl
    }
  }

  dynamic "vpc_connection_properties" {
    for_each = var.vpc_connection_properties != null ? [var.vpc_connection_properties] : []
    content {
      vpc_connection_arn = vpc_connection_properties.value.vpc_connection_arn
    }
  }
}