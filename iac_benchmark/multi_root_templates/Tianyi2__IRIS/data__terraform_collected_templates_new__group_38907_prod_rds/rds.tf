data "aws_vpc" "default" {
  default = true
}

resource "aws_db_instance" "default" {
  identifier                            = "main-db"
  allocated_storage                     = 100
  iam_database_authentication_enabled   = true
  availability_zone                     = "eu-north-1a"
  backup_retention_period               = 30
  engine                                = "postgres"
  engine_version                        = "16.3"
  instance_class                        = "db.t4g.medium"
  username                              = data.doppler_secrets.rds.map.USERNAME
  password                              = data.doppler_secrets.rds.map.PASSWORD
  vpc_security_group_ids                = [aws_security_group.sg.id]
  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  port                                  = 5432
  final_snapshot_identifier             = "main-db-final-snapshot"
  publicly_accessible                   = true
  deletion_protection                   = true
  apply_immediately                     = true

  parameter_group_name = aws_db_parameter_group.default.name
}

resource "aws_db_parameter_group" "default" {
  name   = "main-db-parameter-group"
  family = "postgres16"

  parameter {
    name         = "max_connections"
    value        = "1000"
    apply_method = "pending-reboot"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "sg" {
  name        = "main-db"
  description = "Allow connections from within VPC"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow all inbound traffic"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
