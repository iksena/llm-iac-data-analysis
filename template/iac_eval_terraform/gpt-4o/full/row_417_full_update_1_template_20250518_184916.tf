To address the business need, we will create an Amazon RDS (Relational Database Service) instance with storage autoscaling enabled. This will allow the database to automatically increase its storage capacity when needed, ensuring that the application using the database can handle increased data loads without manual intervention. We will use the AWS provider to manage the resources, and the RDS instance will be configured with a default database engine, such as MySQL. Additionally, we will set up the necessary IAM roles and security groups to ensure secure access to the database.

<iac_template>

```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_db_instance" "example" {
  allocated_storage    = 20
  max_allocated_storage = 100
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = "exampledb"
  username             = "admin"
  password             = "password123"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true

  storage_encrypted = true

  # Enable storage autoscaling
  storage_type = "gp2"

  vpc_security_group_ids = [aws_security_group.db_sg.id]
}

resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Allow MySQL inbound traffic"

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
  name = "rds_autoscaling_role"

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
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
```

</iac_template>

This Terraform configuration sets up an RDS instance with MySQL as the database engine. It enables storage autoscaling by specifying a `max_allocated_storage` value, allowing the database to scale up to 100 GB. The security group allows inbound MySQL traffic on port 3306 from any IP address, which can be adjusted for more restrictive access. An IAM role is created and attached to allow RDS to perform enhanced monitoring, which is useful for autoscaling operations.