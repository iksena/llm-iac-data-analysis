provider "aws" {
  region = "us-east-1"
}

resource "aws_kms_key" "rds_secrets_key" {
  description             = "KMS key for encrypting RDS master password in Secrets Manager"
  deletion_window_in_days = 10
}

resource "aws_secretsmanager_secret" "rds_master_password" {
  name                    = "rds-master-password"
  description             = "Master password for RDS instance"
  kms_key_id              = aws_kms_key.rds_secrets_key.arn
}

resource "aws_secretsmanager_secret_version" "rds_master_password_version" {
  secret_id     = aws_secretsmanager_secret.rds_master_password.id
  secret_string = jsonencode({
    username = "admin"
    password = "ChangeMe123!"  # In a real scenario, use a more secure password
  })
}

resource "aws_db_instance" "example" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = "exampledb"
  username             = jsondecode(aws_secretsmanager_secret_version.rds_master_password_version.secret_string)["username"]
  password             = jsondecode(aws_secretsmanager_secret_version.rds_master_password_version.secret_string)["password"]
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}

output "db_instance_endpoint" {
  value = aws_db_instance.example.endpoint
}