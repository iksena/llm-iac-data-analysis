I'll help you create a Terraform configuration for deploying an AWS Elastic Beanstalk application running a Go application. This configuration will include:

1. An Elastic Beanstalk application
2. An Elastic Beanstalk environment
3. An IAM role and instance profile for the Elastic Beanstalk environment
4. Necessary security group
5. Required variables with default values

Here's the complete Terraform configuration:

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-west-2"
}

# Variables
variable "application_name" {
  description = "Name of the Elastic Beanstalk application"
  type        = string
  default     = "go-application"
}

variable "environment_name" {
  description = "Name of the Elastic Beanstalk environment"
  type        = string
  default     = "go-application-env"
}

# IAM Role for Elastic Beanstalk Service
resource "aws_iam_role" "beanstalk_service_role" {
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

# Attach policies to the service role
resource "aws_iam_role_policy_attachment" "beanstalk_service" {
  role       = aws_iam_role.beanstalk_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

# IAM Role for EC2 instances
resource "aws_iam_role" "beanstalk_ec2_role" {
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

# Attach policies to EC2 role
resource "aws_iam_role_policy_attachment" "beanstalk_web_tier" {
  role       = aws_iam_role.beanstalk_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

# Create EC2 instance profile
resource "aws_iam_instance_profile" "beanstalk_ec2_profile" {
  name = "beanstalk-ec2-profile"
  role = aws_iam_role.beanstalk_ec2_role.name
}

# Create Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "go_app" {
  name        = var.application_name
  description = "Go application using Elastic Beanstalk"
}

# Create Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "go_env" {
  name                = var.environment_name
  application         = aws_elastic_beanstalk_application.go_app.name
  solution_stack_name = "64bit Amazon Linux 2 v2.5.4 running Go 1"
  
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk_ec2_profile.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.beanstalk_service_role.name
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "3"
  }

  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = "t2.micro"
  }
}

# Output the environment URL
output "environment_url" {
  value = aws_elastic_beanstalk_environment.go_env.endpoint_url
}
</iac_template>

This Terraform configuration creates:

1. An AWS Elastic Beanstalk application that can run Go applications
2. An Elastic Beanstalk environment using the Go platform
3. Necessary IAM roles and instance profile for the Elastic Beanstalk service and EC2 instances
4. Basic auto-scaling configuration (min 1, max 3 instances)
5. Uses t2.micro instances for cost-effectiveness
6. Outputs the environment URL once deployed

The configuration uses the AWS provider and sets up all necessary components for running a Go application on Elastic Beanstalk. It includes:

- Proper IAM roles and policies for both the Elastic Beanstalk service and EC2 instances
- A service role for Elastic Beanstalk to manage resources
- An instance profile for the EC2 instances
- The latest Go platform solution stack
- Basic auto-scaling settings
- Instance type configuration

To use this template, you would need to:

1. Have AWS credentials configured
2. Have Terraform installed
3. Run `terraform init`, `terraform plan`, and `terraform apply`
4. Deploy your Go application code to the created environment

The environment will be created with default settings that can be modified by adding or modifying the setting blocks in the Elastic Beanstalk environment resource.