To create a basic AWS RDS instance using Terraform, we will define a configuration that sets up an Amazon RDS instance with default settings. This will include specifying the database engine, instance class, allocated storage, and other necessary parameters. We will also configure the AWS provider to ensure the resources are created in a specific region. Additionally, we will create an IAM role with the necessary permissions to manage RDS instances.

Here is the Terraform HCL program to achieve this:

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
  name                 = "mydb"
  username             = "admin"
  password             = "password123"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}

resource "aws_iam_role" "rds_access" {
  name = "rds-access-role"

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
  name = "rds-access-policy"
  role = aws_iam_role.rds_access.name

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

This configuration will create a MySQL RDS instance with a basic setup, including an IAM role with permissions to manage RDS resources. The RDS instance will be created in the `us-west-2` region. The IAM role and policy ensure that the necessary permissions are in place for managing the RDS instance.