Description:
This Terraform configuration creates an Elastic Beanstalk application named "my_application" along with two Elastic Beanstalk environments (named "env1" and "env2") that both use the same application. An IAM role called "eb_ec2_role" is defined with the trust policy for EC2, and an instance profile called "eb_ec2_profile" is also created and attached to the role. Both Elastic Beanstalk environments reference the instance profile by setting the "IamInstanceProfile" option in their configuration settings. The AWS provider is configured for the "us-east-1" region.

<iac_template>
provider "aws" {
  region  = "us-east-1"
  version = "~> 4.0"
}

# IAM Role for EC2 with necessary trust policy
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

# IAM Instance Profile that uses the above role
resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "eb_ec2_profile"
  role = aws_iam_role.eb_ec2_role.name
}

# Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "my_application" {
  name        = "my_application"
  description = "Elastic Beanstalk Application for both environments"
}

# Elastic Beanstalk Environment 1
resource "aws_elastic_beanstalk_environment" "env1" {
  name                = "env1"
  application         = aws_elastic_beanstalk_application.my_application.name
  solution_stack_name = "64bit Amazon Linux 2 v3.4.7 running Corretto 11"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_ec2_profile.name
  }
}

# Elastic Beanstalk Environment 2
resource "aws_elastic_beanstalk_environment" "env2" {
  name                = "env2"
  application         = aws_elastic_beanstalk_application.my_application.name
  solution_stack_name = "64bit Amazon Linux 2 v3.4.7 running Corretto 11"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_ec2_profile.name
  }
}
</iac_template>