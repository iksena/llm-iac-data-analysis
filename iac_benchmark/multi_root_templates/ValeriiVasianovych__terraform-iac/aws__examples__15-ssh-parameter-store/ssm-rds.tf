resource "random_string" "rds_password" {
  length           = 8    # It means that the length of the password will be 15 characters
  special          = true  # It means that the password will contain special characters
  override_special = "!@#" # Use this special characters in the password 
  keepers = {
    generate-password = "password-v3" # It means that the password will be generated only once
  }
}
# In this example, you can change db password by changing the value of the random_string.rds_password.result
# And RDS password will be updated automatically for RDS mySQL

resource "aws_ssm_parameter" "rds_password" {
  name        = "/prod/mysql"
  description = "RDS password for MySQL"
  type        = "SecureString"
  value       = random_string.rds_password.result
  tags = merge(var.common_tags, {
    Owner  = var.owner
    Region = data.aws_region.current.name
  })
}

resource "aws_db_instance" "default" {
  identifier           = "dev-mysql-db"
  publicly_accessible = true # to make the RDS instance accessible from the internet
  allocated_storage    = 5
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = aws_ssm_parameter.rds_password.value
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true
  tags = merge(var.common_tags, {
    Owner  = var.owner
    Region = data.aws_region.current.name
    DB     = "MySQL"
  })
}



output "rds_password_value" {
  value = nonsensitive(aws_ssm_parameter.rds_password.value)
  # sensitive = true # It means that the value of the output will be hidden
}