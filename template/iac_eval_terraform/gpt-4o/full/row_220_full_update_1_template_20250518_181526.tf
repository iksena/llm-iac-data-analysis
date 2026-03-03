To create a PostgreSQL instance using Terraform, we will use the AWS RDS service. The Terraform configuration will include the necessary resources to set up a PostgreSQL database instance. This will involve defining an RDS instance with the appropriate engine type, version, instance class, allocated storage, and other necessary configurations. We will also create a security group to allow access to the database and an IAM role for any necessary permissions.

Here is the Terraform HCL configuration to achieve this:

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_db_instance" "postgresql" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "13.4"
  instance_class       = "db.t3.micro"
  name                 = "mydatabase"
  username             = "admin"
  password             = "password123"
  parameter_group_name = "default.postgres13"
  skip_final_snapshot  = true

  vpc_security_group_ids = [aws_security_group.db_sg.id]
}

resource "aws_security_group" "db_sg" {
  name        = "allow_postgres"
  description = "Allow PostgreSQL inbound traffic"
  vpc_id      = aws_vpc.main.id

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

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = [aws_subnet.main.id]
}
```
</iac_template>

This configuration sets up a PostgreSQL RDS instance in the `us-west-2` region with a security group that allows inbound traffic on port 5432, which is the default port for PostgreSQL. The database is created with a default username and password, and it is placed within a VPC and subnet for network isolation.