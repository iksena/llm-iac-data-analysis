To create a memory-optimized PostgreSQL database on AWS using Terraform, we will use the Amazon RDS service. We will configure an RDS instance with a memory-optimized instance type suitable for PostgreSQL. Additionally, we will set up the necessary security group to allow access to the database. The Terraform configuration will include the AWS provider setup, an RDS instance, and a security group to control access.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_db_subnet_group" "default" {
  name       = "default"
  subnet_ids = ["subnet-abc123", "subnet-def456"] # Replace with your actual subnet IDs

  tags = {
    Name = "Default subnet group"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow PostgreSQL access"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with more restrictive CIDR blocks in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS Security Group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier              = "memory-optimized-postgres"
  engine                  = "postgres"
  instance_class          = "db.r5.large" # Memory optimized instance type
  allocated_storage       = 20
  name                    = "mydatabase"
  username                = "admin"
  password                = "securepassword" # Replace with a secure password
  parameter_group_name    = "default.postgres12"
  db_subnet_group_name    = aws_db_subnet_group.default.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  skip_final_snapshot     = true

  tags = {
    Name = "Memory Optimized PostgreSQL"
  }
}
```
</iac_template>

This configuration sets up a PostgreSQL RDS instance using a memory-optimized instance type (`db.r5.large`). It includes a security group that allows access to the PostgreSQL port (5432) from any IP address, which should be restricted in a production environment. The database is created with a default subnet group, and you should replace the subnet IDs with those from your VPC. The password should also be replaced with a secure value.