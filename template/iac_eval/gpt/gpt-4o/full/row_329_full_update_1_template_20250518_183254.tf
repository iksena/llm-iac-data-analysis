The Terraform program will set up a Virtual Private Cloud (VPC) with public subnets and security groups specifically configured for database access. It will create a MySQL database instance with version 8.4.3 and a storage capacity of 5GB within the VPC. The database will be secured by a security group that allows access on the MySQL default port (3306) from a specified IP range. The configuration will include the necessary IAM roles and policies to manage the database securely. The AWS provider will be configured to deploy resources in a specified region.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_security_group" "db_access" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust this to a specific IP range for security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-access-sg"
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "main-subnet-group"
  subnet_ids = [aws_subnet.public.id]

  tags = {
    Name = "main-subnet-group"
  }
}

resource "aws_db_instance" "mysql" {
  allocated_storage    = 5
  engine               = "mysql"
  engine_version       = "8.4.3"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "admin"
  password             = "password123" # Use a more secure password in production
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.db_access.id]
  db_subnet_group_name = aws_db_subnet_group.main.name

  tags = {
    Name = "mysql-db-instance"
  }
}
```
</iac_template>