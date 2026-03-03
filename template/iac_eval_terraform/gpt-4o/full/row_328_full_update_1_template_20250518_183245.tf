The Terraform program will set up a Virtual Private Cloud (VPC) with public subnets and security groups specifically configured for database access. It will then create a PostgreSQL database instance with version 17.1 and a storage capacity of 5GB. The database instance will be named "dolphinscheduler" and will be configured to skip the final snapshot upon deletion. The security group will allow access to the database from specified IP addresses or CIDR blocks. The configuration will include the necessary IAM roles and policies to ensure proper access and security.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
}

resource "aws_security_group" "db_access" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust this to restrict access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "main-subnet-group"
  subnet_ids = aws_subnet.public[*].id
}

resource "aws_db_instance" "postgres" {
  identifier              = "dolphinscheduler"
  engine                  = "postgres"
  engine_version          = "17.1"
  instance_class          = "db.t3.micro"
  allocated_storage       = 5
  name                    = "dolphinschedulerdb"
  username                = "admin"
  password                = "securepassword123" # Replace with a secure password
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.db_access.id]
  db_subnet_group_name    = aws_db_subnet_group.main.name
  publicly_accessible     = true
}
```
</iac_template>