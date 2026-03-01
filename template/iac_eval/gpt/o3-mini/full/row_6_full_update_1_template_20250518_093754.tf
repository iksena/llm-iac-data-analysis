This Terraform configuration creates a basic Elastic Beanstalk application and environment. It first configures the AWS provider in the "us-east-1" region. An IAM role named "eb_ec2_role" is created with an assume-role policy allowing EC2 to assume this role. An instance profile called "eb_ec2_profile" is built based on that role. Next, the configuration creates an Elastic Beanstalk application called "my_application" and a corresponding environment. The environment uses a predefined Amazon Linux 2 solution stack running Python 3.8 and sets the instance profile (through the "IamInstanceProfile" configuration option) so that the EC2 instances running in the environment have the proper permissions. All variables are provided with default values so that the configuration is completely deployable.

<iac_template>
provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy resources."
  default     = "us-east-1"
}

resource "aws_iam_role" "eb_ec2_role" {
  name = "eb_ec2_role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "eb_ec2_profile"
  role = aws_iam_role.eb_ec2_role.name
}

resource "aws_elastic_beanstalk_application" "my_application" {
  name        = "my_application"
  description = "Elastic Beanstalk Application for my_application."
}

resource "aws_elastic_beanstalk_environment" "my_environment" {
  name                = "my-environment"
  application         = aws_elastic_beanstalk_application.my_application.name
  solution_stack_name = "64bit Amazon Linux 2 running Python 3.8"
  
  setting {
    namespace  = "aws:autoscaling:launchconfiguration"
    name       = "IamInstanceProfile"
    value      = aws_iam_instance_profile.eb_ec2_profile.name
  }
}

output "application_name" {
  value = aws_elastic_beanstalk_application.my_application.name
}

output "environment_name" {
  value = aws_elastic_beanstalk_environment.my_environment.name
}
</iac_template>