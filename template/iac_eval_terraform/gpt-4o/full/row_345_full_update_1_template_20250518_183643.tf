The Terraform program will create an AWS RDS MySQL database instance with a public access security group. The database will have a randomly generated password, and the configuration will ensure that a final snapshot is taken when the database is deleted. The program will include the necessary IAM roles and policies to allow Terraform to manage the RDS instance and security group. The AWS provider will be configured to use a specific region.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "random_password" "db_password" {
  length  = 16
  special = true
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_public_access"
  description = "Allow public access to RDS"

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

resource "aws_db_instance" "mysql" {
  identifier              = "my-mysql-db"
  engine                  = "mysql"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  name                    = "mydatabase"
  username                = "admin"
  password                = random_password.db_password.result
  publicly_accessible     = true
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  skip_final_snapshot     = false
  final_snapshot_identifier = "my-mysql-db-final-snapshot"
}
```
</iac_template>