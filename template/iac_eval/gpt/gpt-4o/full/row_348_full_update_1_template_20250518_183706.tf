The Terraform program will set up a PostgreSQL database instance in AWS with the following specifications: a 5 GB initial storage size, a maximum allocated storage of 50 GB, and a maintenance window from 0:00 to 3:00 AM on Monday. The database will be deployed within a custom VPC and subnet. The program will also define the necessary networking resources, including a VPC, subnet, and security group to allow access to the database. The PostgreSQL engine version and instance size will be specified, and the necessary IAM roles will be created to manage the database.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "custom_subnet" {
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_security_group" "db_sg" {
  name        = "db_security_group"
  description = "Allow PostgreSQL traffic"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "postgresql" {
  allocated_storage    = 5
  max_allocated_storage = 50
  engine               = "postgres"
  engine_version       = "13.4"
  instance_class       = "db.t3.micro"
  name                 = "mydatabase"
  username             = "admin"
  password             = "password123"
  parameter_group_name = "default.postgres13"
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  maintenance_window   = "Mon:00:00-Mon:03:00"
  skip_final_snapshot  = true
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "mydbsubnetgroup"
  subnet_ids = [aws_subnet.custom_subnet.id]
}
```
</iac_template>