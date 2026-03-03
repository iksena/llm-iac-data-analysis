provider "aws" {
  region = "us-east-1"
}

resource "aws_db_subnet_group" "mysql_subnet_group" {
  name       = "mysql-subnet-group"
  subnet_ids = [
    aws_subnet.subnet_a.id,
    aws_subnet.subnet_b.id,
    aws_subnet.subnet_c.id
  ]

  tags = {
    Name = "MySQL Subnet Group"
  }
}

resource "aws_security_group" "mysql_security_group" {
  name        = "mysql-security-group"
  description = "Allow MySQL traffic"
  vpc_id      = aws_vpc.main.id

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
    Name = "MySQL Security Group"
  }
}

resource "aws_rds_cluster" "mysql_cluster" {
  cluster_identifier      = "mysql-cluster"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.08.1"
  master_username         = "admin"
  master_password         = "yourpassword"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  db_subnet_group_name    = aws_db_subnet_group.mysql_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.mysql_security_group.id]

  tags = {
    Name = "MySQL Cluster"
  }
}

resource "aws_rds_cluster_instance" "mysql_primary_instance" {
  identifier              = "mysql-primary-instance"
  cluster_identifier      = aws_rds_cluster.mysql_cluster.id
  instance_class          = "db.r5.large"
  engine                  = aws_rds_cluster.mysql_cluster.engine
  engine_version          = aws_rds_cluster.mysql_cluster.engine_version
  db_subnet_group_name    = aws_db_subnet_group.mysql_subnet_group.name
  availability_zone       = "us-east-1a"
  publicly_accessible     = false

  tags = {
    Name = "MySQL Primary Instance"
  }
}

resource "aws_rds_cluster_instance" "mysql_read_replica_1" {
  identifier              = "mysql-read-replica-1"
  cluster_identifier      = aws_rds_cluster.mysql_cluster.id
  instance_class          = "db.r5.large"
  engine                  = aws_rds_cluster.mysql_cluster.engine
  engine_version          = aws_rds_cluster.mysql_cluster.engine_version
  db_subnet_group_name    = aws_db_subnet_group.mysql_subnet_group.name
  availability_zone       = "us-east-1b"
  publicly_accessible     = false

  tags = {
    Name = "MySQL Read Replica 1"
  }
}

resource "aws_rds_cluster_instance" "mysql_read_replica_2" {
  identifier              = "mysql-read-replica-2"
  cluster_identifier      = aws_rds_cluster.mysql_cluster.id
  instance_class          = "db.r5.large"
  engine                  = aws_rds_cluster.mysql_cluster.engine
  engine_version          = aws_rds_cluster.mysql_cluster.engine_version
  db_subnet_group_name    = aws_db_subnet_group.mysql_subnet_group.name
  availability_zone       = "us-east-1c"
  publicly_accessible     = false

  tags = {
    Name = "MySQL Read Replica 2"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Main VPC"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Subnet A"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Subnet B"
  }
}

resource "aws_subnet" "subnet_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "Subnet C"
  }
}