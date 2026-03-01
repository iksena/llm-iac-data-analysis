To fulfill the business need, we will create an Amazon RDS instance using AWS's Relational Database Service (RDS) with MySQL as the database engine. We will then create a read replica of this RDS instance to enhance read scalability and availability. The Terraform configuration will include the necessary IAM roles and policies, VPC security group for database access, and the RDS instances themselves. The configuration will be deployed in the `us-west-2` region.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_db_instance" "primary" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "admin"
  password             = "password123"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true

  vpc_security_group_ids = [aws_security_group.db_sg.id]
}

resource "aws_db_instance" "replica" {
  replicate_source_db  = aws_db_instance.primary.id
  instance_class       = "db.t3.micro"
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  parameter_group_name = "default.mysql8.0"

  vpc_security_group_ids = [aws_security_group.db_sg.id]
}

resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Allow MySQL traffic"

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

resource "aws_iam_role" "rds_access" {
  name = "rds_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "rds.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "rds_access_policy" {
  name = "rds_access_policy"
  role = aws_iam_role.rds_access.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "rds:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
```
</iac_template>

This configuration sets up a primary MySQL RDS instance and a read replica in the `us-west-2` region. It also includes a security group to allow MySQL traffic and an IAM role with a policy that allows RDS actions. The database credentials and other sensitive information should be managed securely, possibly using AWS Secrets Manager or SSM Parameter Store in a production environment.