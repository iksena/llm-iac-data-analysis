provider "aws" {
  region = "us-east-1"
}

# VPC and Networking
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "public"
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = [aws_subnet.private.id, aws_subnet.public.id]

  tags = {
    Name = "Main DB subnet group"
  }
}

# Security Groups
resource "aws_security_group" "internal_db" {
  name        = "internal_db"
  description = "Security group for internal database"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }
}

resource "aws_security_group" "public_db" {
  name        = "public_db"
  description = "Security group for public database"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS Instances
resource "aws_db_instance" "internal" {
  identifier           = "internal"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  username            = "admin"
  password            = "password123!" # Change this in production
  skip_final_snapshot = true

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.internal_db.id]
  publicly_accessible    = false
}

resource "aws_db_instance" "public" {
  identifier           = "public"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  username            = "admin"
  password            = "password123!" # Change this in production
  skip_final_snapshot = true

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.public_db.id]
  publicly_accessible    = true
}

# Route 53 Zones
resource "aws_route53_zone" "public" {
  name = "example.com"
}

resource "aws_route53_zone" "private" {
  name = "example.com"

  vpc {
    vpc_id = aws_vpc.main.id
  }
}

# Route 53 Records
resource "aws_route53_record" "db_public" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "db.example.com"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_db_instance.public.endpoint]
}

resource "aws_route53_record" "db_private" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "db.example.com"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_db_instance.internal.endpoint]
}