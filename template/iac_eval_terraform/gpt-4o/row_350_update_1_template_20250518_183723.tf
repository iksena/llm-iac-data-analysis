provider "aws" {
  region = "us-west-2"
}

resource "aws_db_option_group" "option_group_pike" {
  name                     = "option-group-pike"
  engine_name              = "sqlserver-ee"
  major_engine_version     = "11.00"
  option_group_description = "Option group for SQL Server EE with major version 11"

  option {
    option_name = "SQLSERVER_BACKUP_RESTORE"
  }

  option {
    option_name = "SQLSERVER_AUDIT"
  }
}