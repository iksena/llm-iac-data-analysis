provider "aws" {
  region = "us-east-1"
}

# Variables
variable "application_name" {
  description = "Name of the Elastic Beanstalk application"
  default     = "my-app"
}

variable "solution_stack_name" {
  description = "Solution stack name for the Elastic Beanstalk environment"
  default     = "64bit Amazon Linux 2 v5.8.0 running Node.js 18"
}

# Route53 Hosted Zone
resource "aws_route53_zone" "main" {
  name = "example.com"
}

# IAM Role for Elastic Beanstalk
resource "aws_iam_role" "beanstalk_service" {
  name = "beanstalk-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "elasticbeanstalk.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Role for EC2 instances
resource "aws_iam_role" "beanstalk_ec2" {
  name = "beanstalk-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policies to roles
resource "aws_iam_role_policy_attachment" "beanstalk_service" {
  role       = aws_iam_role.beanstalk_service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

resource "aws_iam_role_policy_attachment" "beanstalk_web_tier" {
  role       = aws_iam_role.beanstalk_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

# Instance profile for EC2 instances
resource "aws_iam_instance_profile" "beanstalk" {
  name = "beanstalk-instance-profile"
  role = aws_iam_role.beanstalk_ec2.name
}

# Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "app" {
  name = var.application_name
}

# Blue Environment
resource "aws_elastic_beanstalk_environment" "blue" {
  name                = "${var.application_name}-blue"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = var.solution_stack_name

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.beanstalk_service.name
  }
}

# Green Environment
resource "aws_elastic_beanstalk_environment" "green" {
  name                = "${var.application_name}-green"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = var.solution_stack_name

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.beanstalk_service.name
  }
}

# Route53 weighted records
resource "aws_route53_record" "blue" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "app.example.com"
  type    = "A"

  weighted_routing_policy {
    weight = 50
  }

  alias {
    name                   = aws_elastic_beanstalk_environment.blue.cname
    zone_id                = aws_elastic_beanstalk_environment.blue.cname
    evaluate_target_health = true
  }

  set_identifier = "blue"
}

resource "aws_route53_record" "green" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "app.example.com"
  type    = "A"

  weighted_routing_policy {
    weight = 50
  }

  alias {
    name                   = aws_elastic_beanstalk_environment.green.cname
    zone_id                = aws_elastic_beanstalk_environment.green.cname
    evaluate_target_health = true
  }

  set_identifier = "green"
}