provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "beanstalk_role" {
  name = "beanstalk-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "elasticbeanstalk.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "beanstalk_policy" {
  name   = "beanstalk-service-policy"
  role   = aws_iam_role.beanstalk_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ec2:*",
          "elasticloadbalancing:*",
          "autoscaling:*",
          "cloudwatch:*",
          "s3:*",
          "sns:*",
          "cloudformation:*",
          "rds:*",
          "sqs:*",
          "elasticache:*",
          "dynamodb:*",
          "logs:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_elastic_beanstalk_application" "example" {
  name        = "example-app"
  description = "An example Elastic Beanstalk application"
}

resource "aws_elastic_beanstalk_environment" "example" {
  name                = "example-env"
  application         = aws_elastic_beanstalk_application.example.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.6 running Python 3.8"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_role.beanstalk_role.name
  }
}