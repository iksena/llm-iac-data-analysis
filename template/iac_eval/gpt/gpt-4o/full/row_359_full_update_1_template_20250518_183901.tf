To fulfill the business need, we will create a basic Amazon Lightsail instance using Terraform. This instance will be configured with a simple user data script that runs upon instance launch. The user data script can be used to perform initial setup tasks, such as installing software or configuring the instance. We will also ensure that the necessary IAM roles and policies are in place to allow Terraform to manage the Lightsail resources. The configuration will include a provider setup for AWS in a specified region.

Here is the Terraform HCL configuration:

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
  name   = "lightsail_basic_policy"
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

resource "aws_lightsail_instance" "example" {
  name              = "example-instance"
  availability_zone = "us-west-2a"
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > /home/ec2-user/hello.txt
              EOF
}
```
</iac_template>

This configuration sets up a basic Amazon Lightsail instance in the `us-west-2` region with a simple user data script that writes "Hello, World!" to a file. The IAM role and policy are configured to allow Lightsail operations.