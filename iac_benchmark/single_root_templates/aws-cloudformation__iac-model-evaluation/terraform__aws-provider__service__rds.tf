# ── aws_rds_aurora_module.tf ────────────────────────────────────
# Write Terraform configuration that creates RDS aurora postgres, use module

module "database" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 8.0"

  name           = "example"
  engine         = "aurora-postgresql"
  engine_version = "14.5"
  instance_class = "db.t3.medium"
  master_username = "root"

  vpc_security_group_ids = ["sg-feb876b3"]
  db_subnet_group_name = "default"
}

# ── aws_rds_mysql_protect_destroy.tf ────────────────────────────────────
# Write Terraform configuration that creates RDS instance with mysql engine, protect against destroy

resource "aws_db_instance" "example" {
  allocated_storage    = 20
  db_name              = "example"
  engine               = "mysql"
  engine_version       = "8.0.33"
  instance_class       = "db.t3.small"
  username             = "foo"
  password             = "foobarbaz"
  storage_encrypted    =  true
  
  lifecycle {
    prevent_destroy = true
  }
}