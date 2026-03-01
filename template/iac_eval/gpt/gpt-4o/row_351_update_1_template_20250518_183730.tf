provider "aws" {
  region = "us-east-1"
}

resource "aws_db_option_group" "option_group_pike" {
  name                     = "option-group-pike"
  engine_name              = "sqlserver-ee"
  major_engine_version     = "11"
  option_group_description = "Option group for SQL Server EE with SQLSERVER_AUDIT and TDE"

  option {
    option_name = "SQLSERVER_AUDIT"
  }

  option {
    option_name = "TDE"
  }
}