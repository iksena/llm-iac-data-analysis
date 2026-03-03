To fulfill the business need, we will set up a Virtual Private Cloud (VPC) with public subnets and a security group specifically configured to allow access to a PostgreSQL database instance. The database will be a PostgreSQL version 17.1 instance with a storage capacity of 5GB. The security group will be configured to allow inbound access on the default PostgreSQL port (5432) from a specified IP range. The infrastructure will be deployed in the AWS cloud, using the `us-east-1` region.

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
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
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust this to restrict access as needed
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

resource "aws_db_instance" "postgres" {
  allocated_storage    = 5
  engine               = "postgres"
  engine_version       = "17.1"
  instance_class       = "db.t3.micro"
  name                 = "mydatabase"
  username             = "admin"
  password             = "password123" # Use a more secure password in production
  parameter_group_name = "default.postgres17"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.db_access.id]
  db_subnet_group_name = aws_db_subnet_group.main.name

  tags = {
    Name = "postgres-db"
  }
}
```
</iac_template>

This configuration sets up a VPC with a public subnet, a security group allowing access to the PostgreSQL database, and a PostgreSQL database instance with the specified version and storage capacity. Adjust the security group ingress rules to restrict access as needed for your specific use case.