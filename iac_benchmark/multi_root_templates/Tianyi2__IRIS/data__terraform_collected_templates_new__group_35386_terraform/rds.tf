resource "aws_db_instance" "mlflow_rds" {
  identifier              = var.rds_identifier_mlflow
  allocated_storage       = var.rds_allocated_storage
  engine                  = var.rds_engine
  engine_version          = var.rds_engine_version
  instance_class          = var.rds_instance_class
  multi_az                = false
  username                = var.rds_username_mlflow
  password                = var.rds_password_mlflow
  db_name                 = var.rds_db_name_mlflow
  port                    = var.rds_port_mlflow
  publicly_accessible     = var.rds_publicly_accessible
  vpc_security_group_ids  = [aws_security_group.rds_mlflow_sg.id]
  skip_final_snapshot     = var.rds_skip_final_snapshot
}


resource "aws_db_instance" "mage_ai_rds" {
  identifier              = var.rds_identifier_mage
  allocated_storage       = var.rds_allocated_storage
  engine                  = var.rds_engine
  engine_version          = var.rds_engine_version
  instance_class          = var.rds_instance_class
  multi_az                = false
  username                = var.rds_username_mage
  password                = var.rds_password_mage
  db_name                 = var.rds_db_name_mage
  port                    = var.rds_port_mage
  publicly_accessible     = var.rds_publicly_accessible
  vpc_security_group_ids  = [aws_security_group.rds_mage_ai_sg.id]
  skip_final_snapshot     = var.rds_skip_final_snapshot
}
