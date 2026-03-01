I'll help you create a Terraform configuration that sets up an Elastic Beanstalk application with two environments. The configuration will include the necessary IAM roles and instance profiles, and both environments will use the same application.

Description:
This Terraform configuration will:
1. Create an IAM role for EC2 instances with necessary permissions
2. Create an IAM instance profile
3. Create an Elastic Beanstalk application
4. Create two Elastic Beanstalk environments (prod and dev) using the same application
5. Configure the necessary trust relationships and policies

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

# Attach policies to the IAM role
resource "aws_iam_role_policy_attachment" "eb_web_tier" {
  role       = aws_iam_role.eb_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "eb_worker_tier" {
  role       = aws_iam_role.eb_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
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
resource "aws_elastic_beanstalk_application" "my_application" {
  name        = "my_application"
  description = "My Application running in two environments"
}

# Create Elastic Beanstalk environment - Production
resource "aws_elastic_beanstalk_environment" "production" {
  name                = "production-environment"
  application         = aws_elastic_beanstalk_application.my_application.name
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

# Create Elastic Beanstalk environment - Development
resource "aws_elastic_beanstalk_environment" "development" {
  name                = "development-environment"
  application         = aws_elastic_beanstalk_application.my_application.name
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
    value     = "1"
  }
}
</iac_template>

This configuration creates:
1. An IAM role named "eb_ec2_role" with necessary permissions for Elastic Beanstalk
2. An IAM instance profile named "eb_ec2_profile"
3. An Elastic Beanstalk application named "my_application"
4. Two environments (production and development) using the same application
5. Both environments use Python 3.8 running on Amazon Linux 2
6. Production environment can scale from 1-2 instances, while development environment is limited to 1 instance
7. Both environments use t2.micro instances to keep costs low

The configuration is complete and deployable, with all necessary components properly defined and connected.