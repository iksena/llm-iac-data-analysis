provider "aws" {
  region = "us-east-1"
}

# Create RDS Option Group
resource "aws_db_option_group" "pike_option_group" {
  name                     = "option-group-pike"
  option_group_description = "Option group for SQL Server Enterprise Edition"
  engine_name             = "sqlserver-ee"
  major_engine_version    = "11.00"

  # Example option configuration - uncomment and modify as needed
  # option {
  #   option_name = "SQLSERVER_BACKUP_RESTORE"
  #   
  #   option_settings {
  #     name  = "IAM_ROLE_ARN"
  #     value = aws_iam_role.rds_backup_role.arn
  #   }
  # }

  tags = {
    Name        = "option-group-pike"
    Environment = "Production"
  }

  lifecycle {
    create_before_destroy = true
  }
}