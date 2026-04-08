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
    "module.terraform.io/full-name" = "${local.metadata.package}/${local.metadata.module}"
    "module.terraform.io/instance"  = local.metadata.name
  } : {}
}

data "aws_caller_identity" "this" {}

locals {
  account_id = data.aws_caller_identity.this.account_id

  role_actions = {
    "OWNER" = [
      "quicksight:PassDataSource",
      "quicksight:DescribeDataSourcePermissions",
      "quicksight:UpdateDataSource",
      "quicksight:UpdateDataSourcePermissions",
      "quicksight:DescribeDataSource",
      "quicksight:DeleteDataSource",
    ]
    "USER" = [
      "quicksight:PassDataSource",
      "quicksight:DescribeDataSourcePermissions",
      "quicksight:DescribeDataSource",
    ]
  }
}


###################################################
# QuickSight Data Source
###################################################

resource "aws_quicksight_data_source" "this" {
  region = var.region

  aws_account_id = local.account_id

  data_source_id = var.name
  name           = coalesce(var.display_name, var.name)
  type           = var.type


  ## Data Source
  parameters {
    dynamic "aurora_postgresql" {
      for_each = var.type == "AURORA_POSTGRESQL" ? [var.parameters] : []
      iterator = db

      content {
        database = db.value.database
        host     = db.value.host
        port     = coalesce(lookup(db.value, "port", 5432), 5432)
      }
    }

    dynamic "aurora" {
      for_each = var.type == "AURORA" ? [var.parameters] : []
      iterator = db

      content {
        database = db.value.database
        host     = db.value.host
        port     = coalesce(lookup(db.value, "port", 3306), 3306)
      }
    }

    dynamic "mysql" {
      for_each = var.type == "MYSQL" ? [var.parameters] : []
      iterator = db

      content {
        database = db.value.database
        host     = db.value.host
        port     = coalesce(lookup(db.value, "port", 3306), 3306)
      }
    }

    dynamic "oracle" {
      for_each = var.type == "ORACLE" ? [var.parameters] : []
      iterator = db

      content {
        database = db.value.database
        host     = db.value.host
        port     = coalesce(lookup(db.value, "port", 1521), 1521)
      }
    }

    dynamic "postgresql" {
      for_each = var.type == "POSTGRESQL" ? [var.parameters] : []
      iterator = db

      content {
        database = db.value.database
        host     = db.value.host
        port     = coalesce(lookup(db.value, "port", 5432), 5432)
      }
    }

    dynamic "sql_server" {
      for_each = var.type == "SQLSERVER" ? [var.parameters] : []
      iterator = db

      content {
        database = db.value.database
        host     = db.value.host
        port     = coalesce(lookup(db.value, "port", 1433), 1433)
      }
    }

    dynamic "maria_db" {
      for_each = var.type == "MARIADB" ? [var.parameters] : []
      iterator = db

      content {
        database = db.value.database
        host     = db.value.host
        port     = coalesce(lookup(db.value, "port", 3306), 3306)
      }
    }

    dynamic "athena" {
      for_each = var.type == "ATHENA" ? [var.parameters] : []
      iterator = athena

      content {
        work_group = coalesce(lookup(athena.value, "workgroup", "primary"), "primary")
      }
    }

    dynamic "s3" {
      for_each = var.type == "S3" ? [var.parameters] : []
      iterator = s3

      content {
        role_arn = lookup(s3.value, "iam_role", null)

        manifest_file_location {
          bucket = regex("^s3://([^/]+)/(.*)$", s3.value.manifest_file_location)[0]
          key    = regex("^s3://([^/]+)/(.*)$", s3.value.manifest_file_location)[1]
        }
      }
    }
  }

  dynamic "credentials" {
    for_each = var.credentials != null ? [var.credentials] : []

    content {
      dynamic "credential_pair" {
        for_each = credentials.value.type == "CREDENTIAL_PAIR" ? [credentials.value.credential_pair] : []

        content {
          username = credential_pair.value.username
          password = credential_pair.value.password
        }
      }
      copy_source_arn = credentials.value.type == "COPY_DATA_SOURCE" ? credentials.value.data_source : null
      secret_arn      = credentials.value.type == "SECRETS_MANAGER" ? credentials.value.secrets_manager_secret : null
    }
  }


  ## Network
  dynamic "vpc_connection_properties" {
    for_each = var.vpc_connection.enabled ? [var.vpc_connection] : []

    content {
      vpc_connection_arn = vpc_connection_properties.value.arn
    }
  }

  ssl_properties {
    disable_ssl = !var.ssl.enabled
  }


  ## Access Control
  dynamic "permission" {
    for_each = var.permissions

    content {
      principal = permission.value.principal
      actions = (permission.value.role != null
        ? local.role_actions[permission.value.role]
        : permission.value.actions
      )
    }
  }


  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
    var.tags,
  )
}
