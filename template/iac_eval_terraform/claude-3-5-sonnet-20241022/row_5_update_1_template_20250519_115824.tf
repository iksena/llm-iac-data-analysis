provider "aws" {
  region = "us-west-2"
}

# Variables
variable "db_name" {
  description = "Database name"
  default     = "mydb"
}

variable "domain_name" {
  description = "Domain name for the Route 53 zone"
  default     = "example.com"
}

# Create a VPC for the databases
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main"
  }
}

# Create a subnet group for RDS
resource "aws_db_subnet_group" "main" {
  name        = "main"
  description = "Main DB subnet group"
  subnet_ids  = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}

# Create subnets
resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "subnet2"
  }
}

# Create primary DB instance
resource "aws_db_instance" "primary" {
  identifier           = "primary"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  db_name             = var.db_name
  username            = "admin"
  password            = "password123!" # Change this in production
  skip_final_snapshot = true
  
  db_subnet_group_name = aws_db_subnet_group.main.name
}

# Create first read replica
resource "aws_db_instance" "replica-1" {
  identifier           = "replica-1"
  instance_class      = "db.t3.micro"
  replicate_source_db = aws_db_instance.primary.identifier
  skip_final_snapshot = true
}

# Create second read replica
resource "aws_db_instance" "replica-2" {
  identifier           = "replica-2"
  instance_class      = "db.t3.micro"
  replicate_source_db = aws_db_instance.primary.identifier
  skip_final_snapshot = true
}

# Create Route 53 zone
resource "aws_route53_zone" "main" {
  name = var.domain_name

  tags = {
    Environment = "main"
  }
}

# Create weighted record for replica-1
resource "aws_route53_record" "replica1" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "db.${var.domain_name}"
  type    = "CNAME"
  ttl     = "300"
  
  weighted_routing_policy {
    weight = 50
  }
  
  set_identifier = "replica1"
  records        = [aws_db_instance.replica-1.endpoint]
}

# Create weighted record for replica-2
resource "aws_route53_record" "replica2" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "db.${var.domain_name}"
  type    = "CNAME"
  ttl     = "300"
  
  weighted_routing_policy {
    weight = 50
  }
  
  set_identifier = "replica2"
  records        = [aws_db_instance.replica-2.endpoint]
}