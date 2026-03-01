To create a basic Amazon Lightsail instance using Terraform, we will define a Terraform configuration that sets up a Lightsail instance in a specified region. The configuration will include the necessary provider configuration for AWS, and we will specify the instance blueprint and bundle to use. Additionally, we will create an IAM role with the necessary permissions to manage Lightsail resources.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "lightsail_role" {
  name = "lightsail_basic_role"

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
  name = "lightsail_basic_policy"
  role = aws_iam_role.lightsail_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lightsail:*"
        ]
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_lightsail_instance" "example" {
  name              = "example-instance"
  availability_zone = "us-west-2a"
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"

  tags = {
    Name = "ExampleInstance"
  }
}

output "instance_name" {
  value = aws_lightsail_instance.example.name
}

output "instance_arn" {
  value = aws_lightsail_instance.example.arn
}
```
</iac_template>

This configuration sets up a basic Amazon Lightsail instance using the Amazon Linux 2 blueprint and a nano bundle. It also creates an IAM role with permissions to manage Lightsail resources. The instance is created in the `us-west-2` region, and outputs are provided to display the instance name and ARN after deployment.