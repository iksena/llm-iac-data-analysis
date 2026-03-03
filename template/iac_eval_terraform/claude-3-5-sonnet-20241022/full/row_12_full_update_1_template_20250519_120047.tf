I'll help you create a Terraform configuration for Blue/Green deployment using AWS Elastic Beanstalk with Route53 weighted routing policy. This setup will include:

1. Two Elastic Beanstalk environments (blue and green)
2. Route53 hosted zone and weighted routing records
3. Necessary IAM roles and instance profiles
4. Required variables and providers

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
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
</iac_template>

This configuration creates:
1. A Route53 hosted zone for example.com
2. Required IAM roles and instance profile for Elastic Beanstalk
3. An Elastic Beanstalk application with two environments (blue and green)
4. Route53 weighted routing records that distribute traffic 50/50 between the blue and green environments

To use this configuration:
1. Replace "example.com" with your actual domain name
2. Adjust the solution_stack_name variable to match your application requirements
3. Modify the application_name variable as needed
4. Update the region in the provider block if needed

The weighted routing policy is set to 50/50 distribution between blue and green environments. You can adjust the weights as needed during deployment updates by modifying the weight values in the weighted_routing_policy blocks.