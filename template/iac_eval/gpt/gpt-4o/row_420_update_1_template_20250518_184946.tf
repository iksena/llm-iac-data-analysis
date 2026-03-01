provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "my_mysql_instance" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "admin"
  password             = "password123"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}

resource "aws_db_snapshot" "my_mysql_snapshot" {
  db_instance_identifier = aws_db_instance.my_mysql_instance.id
  db_snapshot_identifier = "my-mysql-snapshot"
}

output "db_instance_endpoint" {
  value = aws_db_instance.my_mysql_instance.endpoint
}

output "db_snapshot_id" {
  value = aws_db_snapshot.my_mysql_snapshot.id
}