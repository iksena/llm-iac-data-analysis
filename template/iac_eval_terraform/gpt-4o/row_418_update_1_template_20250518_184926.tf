provider "aws" {
  region = "us-west-2"
}

resource "aws_secretsmanager_secret" "db_password" {
  name        = "rds-master-password"
  description = "Master password for RDS instance"
}

resource "aws_secretsmanager_secret_version" "db_password_version" {
  secret_id     = aws_secretsmanager_secret.db_password.id
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
  username             = jsondecode(aws_secretsmanager_secret_version.db_password_version.secret_string)["username"]
  password             = jsondecode(aws_secretsmanager_secret_version.db_password_version.secret_string)["password"]
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true

  depends_on = [aws_secretsmanager_secret_version.db_password_version]
}

resource "aws_iam_role" "rds_secrets_manager_access" {
  name = "rds-secrets-manager-access"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "rds.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "rds_secrets_manager_policy" {
  name        = "rds-secrets-manager-policy"
  description = "Policy to allow RDS to access Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
        Resource = aws_secretsmanager_secret.db_password.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.rds_secrets_manager_access.name
  policy_arn = aws_iam_policy.rds_secrets_manager_policy.arn
}