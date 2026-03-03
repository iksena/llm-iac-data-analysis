provider "aws" {
  region = "us-east-1"
}

# Random password generation
resource "random_password" "mysql_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Random ID for RDS identifier
resource "random_id" "mysql_id" {
  byte_length = 4
}

# Create VPC Security Group for RDS
resource "aws_security_group" "mysql_sg" {
  name        = "mysql-security-group"
  description = "Security group for MySQL RDS instance"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mysql-security-group"
  }
}

# Create RDS Instance
resource "aws_db_instance" "mysql" {
  identifier        = "mysql-${random_id.mysql_id.hex}"
  engine            = "mysql"
  engine_version    = "8.0.28"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  
  db_name  = "mydb"
  username = "admin"
  password = random_password.mysql_password.result

  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]

  tags = {
    Name = "mysql-database"
  }
}

# Output the database endpoint and generated password
output "database_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "database_password" {
  value     = random_password.mysql_password.result
  sensitive = true
}