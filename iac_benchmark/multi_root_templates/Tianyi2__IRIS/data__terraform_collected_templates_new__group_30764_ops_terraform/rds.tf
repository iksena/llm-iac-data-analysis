resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]

  tags = {
    Owner: "TimS"
    Name: "tims-kunlaquota-rds-subnet-main"
  }
}

resource "aws_db_instance" "kunlaquotadb" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "16.3"
  instance_class       = "db.t3.micro" # Free tier instance type
  username             = "kunlaquotaadmin"
  password             = "kunlaquotapassword"
  parameter_group_name = "default.postgres16"
  skip_final_snapshot  = true

  db_subnet_group_name = aws_db_subnet_group.default.name

  vpc_security_group_ids = [aws_security_group.rds.id]

  tags = {
    Owner: "TimS"
    Name: "tims-kunlaquota-rds-postgres"
  }
}

resource "aws_security_group" "rds" {
  name_prefix = "rds-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }

  tags = {
    Owner: "TimS"
    Name: "tims-kunlaquota-rds-security-group"
  }
}
