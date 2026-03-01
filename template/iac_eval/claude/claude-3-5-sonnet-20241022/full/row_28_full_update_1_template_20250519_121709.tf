I'll help you create a Terraform configuration for deploying an AWS Elastic Beanstalk application. This template will:

1. Create an Elastic Beanstalk application
2. Create an Elastic Beanstalk environment
3. Set up the necessary IAM roles and instance profile
4. Configure basic environment settings
5. Use a sample application version

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Variables with default values
variable "application_name" {
  description = "Name of the Elastic Beanstalk application"
  default     = "my-app"
}

variable "environment_name" {
  description = "Name of the Elastic Beanstalk environment"
  default     = "my-app-environment"
}

# Create IAM role for Elastic Beanstalk service
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

# Attach managed policies to the service role
resource "aws_iam_role_policy_attachment" "beanstalk_service" {
  role       = aws_iam_role.beanstalk_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

# Create IAM role for EC2 instances
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

# Attach managed policies to the EC2 role
resource "aws_iam_role_policy_attachment" "beanstalk_web_tier" {
  role       = aws_iam_role.beanstalk_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

# Create instance profile
resource "aws_iam_instance_profile" "beanstalk_instance_profile" {
  name = "beanstalk-instance-profile"
  role = aws_iam_role.beanstalk_ec2_role.name
}

# Create Elastic Beanstalk application
resource "aws_elastic_beanstalk_application" "application" {
  name        = var.application_name
  description = "Sample application created by Terraform"
}

# Create Elastic Beanstalk environment
resource "aws_elastic_beanstalk_environment" "environment" {
  name                = var.environment_name
  application         = aws_elastic_beanstalk_application.application.name
  solution_stack_name = "64bit Amazon Linux 2 v5.6.4 running Node.js 18"
  
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk_instance_profile.name
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

# Output values
output "environment_endpoint" {
  value = aws_elastic_beanstalk_environment.environment.endpoint_url
}
</iac_template>

This Terraform configuration creates:

1. An AWS provider configuration for the us-west-2 region
2. Variables for application and environment names with default values
3. IAM roles and instance profile required for Elastic Beanstalk
4. An Elastic Beanstalk application
5. An Elastic Beanstalk environment with:
   - Node.js 18 platform
   - Auto-scaling configuration (1-3 instances)
   - t2.micro instance type
   - Necessary IAM roles and instance profile
6. An output for the environment endpoint URL

The configuration includes all necessary components for a working Elastic Beanstalk application. You can customize the variables and settings according to your needs. The environment will use a Node.js platform, but you can change the solution_stack_name to use a different platform if needed.

To use this template, you would need to:
1. Initialize Terraform
2. Authenticate with AWS
3. Run terraform plan and terraform apply
4. Deploy your application code through the Elastic Beanstalk environment

Remember that running this configuration will create resources in your AWS account that may incur costs.