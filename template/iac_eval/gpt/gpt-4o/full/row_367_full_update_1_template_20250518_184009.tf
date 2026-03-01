To fulfill the business need, we will create an AWS Lightsail instance with a MySQL database. AWS Lightsail is a simplified cloud platform that provides everything needed to build an application or website, including virtual servers, storage, and networking. In this configuration, we will set up a Lightsail instance with a MySQL database blueprint. We will also configure the necessary IAM roles and policies to allow Terraform to manage the Lightsail resources.

Below is the Terraform HCL configuration to achieve this:

<iac_template>

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "lightsail_role" {
  name = "lightsail_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lightsail.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lightsail_policy" {
  name   = "lightsail_access_policy"
  role   = aws_iam_role.lightsail_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lightsail:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_lightsail_instance" "mysql_instance" {
  name              = "mysql-lightsail-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "mysql_5_7"
  bundle_id         = "micro_2_0"

  tags = {
    Name = "MySQLInstance"
  }
}

output "instance_name" {
  value = aws_lightsail_instance.mysql_instance.name
}

output "instance_arn" {
  value = aws_lightsail_instance.mysql_instance.arn
}
```

</iac_template>

This configuration sets up a Lightsail instance using the MySQL 5.7 blueprint in the `us-east-1` region. The instance is tagged for easy identification, and outputs are provided to display the instance name and ARN after deployment. The IAM role and policy ensure that the necessary permissions are in place for managing Lightsail resources.