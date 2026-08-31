resource "aws_db_instance" "main" {
  allocated_storage      = 5
  identifier             = "my-postgres"
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro"
  username               = "postgres"
  password               = "postgres"
  skip_final_snapshot    = true
  storage_type           = "gp2"
  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.private.id]
  parameter_group_name   = aws_db_parameter_group.main.name
  port                   = 5432
}

resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = aws_subnet.private[*].id
}

resource "aws_db_parameter_group" "main" {
  name   = "main-pg"
  family = "postgres15"

  lifecycle {
    create_before_destroy = true
  }
}
