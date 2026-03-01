To fulfill the business need, we will create an AWS RDS instance using Terraform. The configuration will include a randomly generated identifier and password for the RDS instance. We will use the `random` provider to generate these values. The RDS instance will be created in a specified AWS region, and we will ensure that the necessary IAM roles and security groups are in place to allow access to the RDS instance. The Terraform configuration will also include a provider configuration for AWS.

Here is the Terraform HCL program:

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "random_id" "rds_identifier" {
  byte_length = 8
}

resource "random_password" "rds_password" {
  length  = 16
  special = true
}

resource "aws_db_instance" "example" {
  identifier              = random_id.rds_identifier.hex
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t2.micro"
  name                    = "exampledb"
  username                = "admin"
  password                = random_password.rds_password.result
  parameter_group_name    = "default.mysql8.0"
  skip_final_snapshot     = true

  # VPC security group to allow access
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow MySQL access"

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
}
```
</iac_template>

This configuration will create an RDS instance with a randomly generated identifier and password. The RDS instance will be accessible from any IP address due to the security group configuration, which allows inbound traffic on port 3306 (the default MySQL port). Adjust the security group rules as needed to restrict access to specific IP ranges for better security.