terraform {
  required_version = ">= 0.12.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}


##DB
resource "aws_secretsmanager_secret" "weasel_crm_rds_credentials" {
  name = var.db_credentials
}

resource "aws_secretsmanager_secret_version" "current" {
  secret_id     = aws_secretsmanager_secret.weasel_crm_rds_credentials.id
  secret_string = jsonencode({ username = "admin", password = "BenchmarkPassw0rd!" })
}



resource "aws_db_instance" "weasel_crm_rds" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0.46"
  instance_class       = "db.t2.micro"
  db_name              = "weasel_crm_db"
  username             = jsondecode(aws_secretsmanager_secret_version.current.secret_string)["username"]
  password             = jsondecode(aws_secretsmanager_secret_version.current.secret_string)["password"]
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true #use in case you don't need to save db snapshot; in case db snapshot is necessary - comment this line and uncomment 2 next lines
  #skip_final_snapshot   = false
  #final_snapshot_identifier = "weasel-crm-db-final-snapshot"
  vpc_security_group_ids = [aws_security_group.weasel_crm_rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.weasel_crm_db_subnet_group.id
}


# S3 Bucket
resource "aws_s3_bucket" "private_bucket" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_public_access_block" "private_bucket_policy" {
  bucket = aws_s3_bucket.private_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}