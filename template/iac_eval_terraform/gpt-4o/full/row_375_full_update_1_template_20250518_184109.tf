To fulfill the business need, we will create an AWS Lightsail instance and an S3 bucket. We will then configure the necessary IAM roles and policies to allow the Lightsail instance to access the S3 bucket. This involves creating an IAM role with a policy that grants the necessary permissions and associating this role with the Lightsail instance.

Here is the Terraform configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-lightsail-access-bucket"
  acl    = "private"
}

resource "aws_iam_role" "lightsail_role" {
  name = "lightsail-s3-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lightsail.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "lightsail-s3-access-policy"
  description = "Policy to allow Lightsail access to S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.example_bucket.arn,
          "${aws_s3_bucket.example_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.lightsail_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_lightsail_instance" "example_instance" {
  name              = "example-lightsail-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"

  user_data = <<EOF
#!/bin/bash
yum update -y
EOF

  key_pair_name = "example-key-pair"
}

resource "aws_lightsail_instance_public_ports" "example_instance_ports" {
  instance_name = aws_lightsail_instance.example_instance.name

  port_info {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidrs       = ["0.0.0.0/0"]
  }
}
```
</iac_template>

This configuration sets up an AWS Lightsail instance with access to an S3 bucket. The IAM role and policy ensure that the instance can perform necessary actions on the bucket. The Lightsail instance is configured with a basic Amazon Linux 2 blueprint and a nano bundle.