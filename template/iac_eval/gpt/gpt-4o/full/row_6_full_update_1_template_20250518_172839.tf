The Terraform program will create an AWS Elastic Beanstalk environment along with an Elastic Beanstalk application. It will also set up the necessary IAM roles and instance profiles required for the Elastic Beanstalk environment to function properly. The IAM role will be named "eb_ec2_role", and the instance profile will be named "eb_ec2_profile". The Elastic Beanstalk application will be named "my_application". The configuration will be deployed in the "us-west-2" region.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "eb_ec2_role" {
  name = "eb_ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eb_ec2_role_policy" {
  role       = aws_iam_role.eb_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "eb_ec2_profile"
  role = aws_iam_role.eb_ec2_role.name
}

resource "aws_elastic_beanstalk_application" "my_application" {
  name        = "my_application"
  description = "My Elastic Beanstalk Application"
}

resource "aws_elastic_beanstalk_environment" "my_environment" {
  name                = "my-environment"
  application         = aws_elastic_beanstalk_application.my_application.name
  solution_stack_name = "64bit Amazon Linux 2 v5.4.4 running Node.js 14"

  settings = [
    {
      namespace = "aws:autoscaling:launchconfiguration"
      name      = "IamInstanceProfile"
      value     = aws_iam_instance_profile.eb_ec2_profile.name
    }
  ]
}
```
</iac_template>