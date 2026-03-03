To fulfill the business need, we will create an Amazon RDS MySQL instance with a storage size of 20GB. The instance will have a randomly generated identifier and password for the master user. We will use the AWS provider to manage the resources, and the Terraform random provider to generate the random values for the identifier and password. The configuration will include the necessary IAM roles and security group to allow access to the RDS instance.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "random_id" "rds_identifier" {
  byte_length = 8
}

resource "random_password" "rds_password" {
  length  = 16
  special = true
}

resource "aws_db_instance" "mysql" {
  identifier              = random_id.rds_identifier.hex
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  name                    = "mydatabase"
  username                = "admin"
  password                = random_password.rds_password.result
  parameter_group_name    = "default.mysql8.0"
  skip_final_snapshot     = true

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

This configuration will create a MySQL RDS instance with a 20GB storage size, a randomly generated identifier, and a secure password. The security group allows inbound MySQL traffic from any IP address, which is suitable for testing but should be restricted in a production environment.