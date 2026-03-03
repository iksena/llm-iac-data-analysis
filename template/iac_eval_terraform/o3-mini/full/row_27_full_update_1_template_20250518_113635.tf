Below is a description of the Terraform program that meets your requirements:

• The configuration uses the AWS provider in the "us-east-1" region (this can be overridden using the aws_region variable).  
• An IAM role named "eb_ec2_role" is created with an assume-role policy that allows EC2 instances to assume the role.  
• An IAM instance profile named "eb_ec2_profile" is created and linked to the above IAM role.  
• An Elastic Beanstalk application named "my_application" is created.  
• Finally, an Elastic Beanstalk environment is created as a WebServer environment linked to "my_application" using a popular solution stack. The instance profile is passed to the environment settings, ensuring that EC2 instances launched within the environment assume the necessary role.  

The complete Terraform HCL configuration is provided below:

<iac_template>
provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

resource "aws_iam_role" "eb_ec2_role" {
  name = "eb_ec2_role"
  
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "eb_ec2_profile"
  role = aws_iam_role.eb_ec2_role.name
}

resource "aws_elastic_beanstalk_application" "my_application" {
  name = "my_application"
}

resource "aws_elastic_beanstalk_environment" "webserver_env" {
  name                = "webserver-env"
  application         = aws_elastic_beanstalk_application.my_application.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.6 running Node.js"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_ec2_profile.name
  }
}
</iac_template>