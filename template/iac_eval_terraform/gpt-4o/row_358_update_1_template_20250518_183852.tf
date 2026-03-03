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