To create a MySQL instance using Terraform, we will use the AWS RDS (Relational Database Service) to provision a MySQL database. The configuration will include setting up the necessary VPC, subnets, and security groups to ensure the database is accessible securely. We will also define the RDS instance with the required parameters such as instance class, allocated storage, and database credentials. The Terraform configuration will be deployable in the AWS region `us-west-2`.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.main.id

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

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "admin"
  password             = "password123"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
}

resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = [aws_subnet.main.id]
}
```
</iac_template>

This configuration sets up a MySQL RDS instance in the `us-west-2` region with a basic VPC and subnet configuration. The security group allows inbound traffic on port 3306, which is the default port for MySQL. The database instance is created with a default username and password, which should be changed to more secure values in a production environment.