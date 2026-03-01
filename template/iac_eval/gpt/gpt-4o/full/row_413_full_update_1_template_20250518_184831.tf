To fulfill the business need, we will create an AWS RDS instance from an existing snapshot. This involves specifying the snapshot identifier and configuring the RDS instance with necessary parameters such as instance class, allocated storage, and other settings. We will also set up the necessary IAM roles and policies to allow Terraform to manage the RDS resources. The configuration will use the AWS provider and will be set in a specific region. 

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_db_instance" "from_snapshot" {
  identifier              = "my-db-instance"
  snapshot_identifier     = "my-db-snapshot"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  username                = "admin"
  password                = "password1234"
  parameter_group_name    = "default.mysql8.0"
  skip_final_snapshot     = true

  tags = {
    Name = "MyDBInstanceFromSnapshot"
  }
}

resource "aws_iam_role" "rds_access_role" {
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
  role = aws_iam_role.rds_access_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "rds:DescribeDBSnapshots",
          "rds:DescribeDBInstances",
          "rds:CreateDBInstance"
        ]
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}
```
</iac_template>

This configuration will create an RDS instance from the specified snapshot in the `us-west-2` region. The IAM role and policy are set up to allow necessary actions on RDS resources. Make sure to replace `"my-db-snapshot"` with the actual snapshot identifier you want to use.