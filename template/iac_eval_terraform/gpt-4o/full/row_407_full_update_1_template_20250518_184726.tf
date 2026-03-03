To create a basic AWS SQL database using Terraform, we will define a configuration that sets up an Amazon RDS instance. This will include specifying the database engine, instance class, allocated storage, and other necessary parameters. We will also create a security group to allow access to the database. The configuration will use the AWS provider and will be set in a specific region. Additionally, we will define an IAM role with the necessary permissions to manage the RDS instance.

<iac_template>

```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  name                 = "mydatabase"
  username             = "admin"
  password             = "password123"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true

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

resource "aws_iam_role" "rds_role" {
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

resource "aws_iam_role_policy_attachment" "rds_policy_attachment" {
  role       = aws_iam_role.rds_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSFullAccess"
}
```

</iac_template>

This configuration will create a MySQL RDS instance with a security group that allows inbound traffic on port 3306 from any IP address. The IAM role is set up to allow RDS to assume the necessary permissions. The database instance is configured with a default username and password, which should be changed to secure values in a production environment.