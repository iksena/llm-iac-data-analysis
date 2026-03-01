I'll help you create a Terraform configuration for an AWS Elastic Beanstalk environment with the specified IAM roles and application name. This configuration will:

1. Create an IAM role for EC2 instances with necessary permissions
2. Create an IAM instance profile
3. Create an Elastic Beanstalk application
4. Create an Elastic Beanstalk environment

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Create IAM role for EC2 instances
resource "aws_iam_role" "eb_ec2_role" {
  name = "eb_ec2_role"

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

# Attach necessary policies to the IAM role
resource "aws_iam_role_policy_attachment" "eb_web_tier" {
  role       = aws_iam_role.eb_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "eb_multicontainer_docker" {
  role       = aws_iam_role.eb_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}

# Create IAM instance profile
resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "eb_ec2_profile"
  role = aws_iam_role.eb_ec2_role.name
}

# Create Elastic Beanstalk application
resource "aws_elastic_beanstalk_application" "my_app" {
  name        = "my_application"
  description = "My Elastic Beanstalk Application"
}

# Create Elastic Beanstalk environment
resource "aws_elastic_beanstalk_environment" "my_env" {
  name                = "my-environment"
  application         = aws_elastic_beanstalk_application.my_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.5.9 running Python 3.8"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_ec2_profile.name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "2"
  }
}
</iac_template>

This configuration creates:
1. An IAM role named "eb_ec2_role" with the necessary permissions for EC2 instances in Elastic Beanstalk
2. Required policy attachments for the IAM role
3. An IAM instance profile named "eb_ec2_profile"
4. An Elastic Beanstalk application named "my_application"
5. An Elastic Beanstalk environment with basic configurations including:
   - Python 3.8 platform
   - t2.micro instance type
   - Auto-scaling group with min size 1 and max size 2
   - Proper IAM instance profile association

The configuration uses the AWS provider in the us-west-2 region. You can modify the region as needed. The solution stack name used is for Python 3.8, but you can change it to any other supported platform version based on your requirements.