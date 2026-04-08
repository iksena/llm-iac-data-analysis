resource "aws_db_subnet_group" "default_db" {
  name       = "${var.environment}-default_db"
  subnet_ids = module.vpc_networking.private_subnet_ids
}

resource "aws_db_instance" "default_db" {
  identifier              = var.db_identifier
  allocated_storage       = var.db_storage_size
  max_allocated_storage   = var.db_max_allocated_storage
  storage_type            = "gp2"
  engine                  = "postgres"
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class
  name                    = var.db_name
  username                = "dbadmin"
  password                = var.db_pwd
  parameter_group_name    = "default.postgres11"
  publicly_accessible     = var.db_publicly_accesible
  skip_final_snapshot     = var.db_skip_final_snapshot
  backup_retention_period = var.db_backup_retention_period
  db_subnet_group_name    = aws_db_subnet_group.default_db.name
  vpc_security_group_ids  = [aws_security_group.api.id]
}
