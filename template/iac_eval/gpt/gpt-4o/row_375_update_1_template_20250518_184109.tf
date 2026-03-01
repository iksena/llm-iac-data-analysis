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