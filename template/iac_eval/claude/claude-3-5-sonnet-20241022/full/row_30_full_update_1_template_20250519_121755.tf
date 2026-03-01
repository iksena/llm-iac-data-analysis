I'll help you create a Terraform configuration to deploy a web application using AWS Elastic Beanstalk, which is a fully managed service that makes it easy to deploy, run, and scale web applications. This configuration will:

1. Create an Elastic Beanstalk application
2. Create an Elastic Beanstalk environment
3. Set up the necessary IAM roles and instance profile
4. Configure basic environment settings for a web application

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Variables with default values
variable "application_name" {
  description = "Name of the Elastic Beanstalk application"
  type        = string
  default     = "my-web-app"
}

variable "environment_name" {
  description = "Name of the Elastic Beanstalk environment"
  type        = string
  default     = "my-web-app-environment"
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
resource "aws_iam_instance_profile" "beanstalk_ec2_profile" {
  name = "beanstalk-ec2-profile"
  role = aws_iam_role.beanstalk_ec2_role.name
}

# Create Elastic Beanstalk application
resource "aws_elastic_beanstalk_application" "web_app" {
  name        = var.application_name
  description = "Web application deployed using Elastic Beanstalk"
}

# Create Elastic Beanstalk environment
resource "aws_elastic_beanstalk_environment" "web_app_env" {
  name                = var.environment_name
  application         = aws_elastic_beanstalk_application.web_app.name
  solution_stack_name = "64bit Amazon Linux 2 v5.6.4 running Node.js 18"
  
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
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthyThresholdCount"
    value     = "3"
  }
}

# Output the environment URL
output "environment_url" {
  value = aws_elastic_beanstalk_environment.web_app_env.endpoint_url
}
</iac_template>

This Terraform configuration creates an AWS Elastic Beanstalk environment that will:

1. Set up the necessary IAM roles and instance profile for both the Elastic Beanstalk service and EC2 instances
2. Create an Elastic Beanstalk application
3. Create an Elastic Beanstalk environment with:
   - Node.js 18 platform (you can change this to other supported platforms)
   - Auto-scaling configuration (min 1, max 3 instances)
   - Load balanced environment
   - Health check configuration
4. Output the environment URL once deployed

The configuration includes all necessary components and can be deployed with standard Terraform commands. It uses the AWS provider and sets up everything in the us-west-2 region (which you can modify as needed).

To deploy your application, you would need to:
1. Initialize Terraform: `terraform init`
2. Review the changes: `terraform plan`
3. Apply the configuration: `terraform apply`

After deployment, you can deploy your application code through the Elastic Beanstalk console or using the AWS CLI/SDK.