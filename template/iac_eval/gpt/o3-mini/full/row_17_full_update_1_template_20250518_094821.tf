Below is the description of the Terraform configuration that meets the business need:

• It uses the AWS provider in the us-west-2 region.
• It creates an IAM role to be assumed by EC2 instances and an instance profile named "eb_ec2_profile".
• It creates an Elastic Beanstalk application and an environment. In the environment configuration, option settings are set for autoscaling based on CPU utilization thresholds (with lower and upper thresholds) as well as the instance profile for launch configurations.
• It deploys an RDS MySQL database instance named "my_db1". In addition, the Elastic Beanstalk environment is configured with environment variables to provide the DB connection info.
• All variables (such as the EB solution stack) are provided with default values so that this configuration is deployable as-is.

Below is the complete Terraform HCL code within the required <iac_template> tags:

<iac_template>
provider "aws" {
  region = "us-west-2"
}

# IAM role for Elastic Beanstalk EC2 instances
resource "aws_iam_role" "eb_ec2_role" {
  name = "eb_ec2_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# Instance profile with the fixed name "eb_ec2_profile"
resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "eb_ec2_profile"
  role = aws_iam_role.eb_ec2_role.name
}

# Elastic Beanstalk application
resource "aws_elastic_beanstalk_application" "eb_app" {
  name        = "my-eb-app"
  description = "Elastic Beanstalk application with autoscaling and RDS"
}

# Elastic Beanstalk environment with autoscaling and DB connection settings
resource "aws_elastic_beanstalk_environment" "eb_env" {
  name                = "my-eb-environment"
  application         = aws_elastic_beanstalk_application.eb_app.name
  solution_stack_name = var.solution_stack

  setting {
    namespace  = "aws:autoscaling:trigger"
    name       = "MetricName"
    value      = "CPUUtilization"
  }
  setting {
    namespace  = "aws:autoscaling:trigger"
    name       = "UpperThreshold"
    value      = "80"
  }
  setting {
    namespace  = "aws:autoscaling:trigger"
    name       = "LowerThreshold"
    value      = "20"
  }
  setting {
    namespace  = "aws:autoscaling:trigger"
    name       = "Statistic"
    value      = "Average"
  }
  setting {
    namespace  = "aws:autoscaling:asg"
    name       = "MaxSize"
    value      = "4"
  }
  setting {
    namespace  = "aws:autoscaling:asg"
    name       = "MinSize"
    value      = "1"
  }
  setting {
    namespace  = "aws:autoscaling:launchconfiguration"
    name       = "IamInstanceProfile"
    value      = aws_iam_instance_profile.eb_ec2_profile.name
  }
  # Environment properties to connect to the RDS database
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_HOSTNAME"
    value     = aws_db_instance.my_db1.address
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_PORT"
    value     = tostring(aws_db_instance.my_db1.port)
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_DB_NAME"
    value     = aws_db_instance.my_db1.name
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_USERNAME"
    value     = aws_db_instance.my_db1.username
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_PASSWORD"
    value     = aws_db_instance.my_db1.password
  }

  depends_on = [aws_db_instance.my_db1]
}

# RDS MySQL database instance named "my_db1"
resource "aws_db_instance" "my_db1" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "my_db1"
  username             = "admin"
  password             = "password123"
  identifier           = "my-db1"
  skip_final_snapshot  = true
  publicly_accessible  = true

  # Use the default VPC's default security group. In production, you would likely specify security groups.
  vpc_security_group_ids = [data.aws_security_group.default.id]
}

# Data source to reference the default security group in the default VPC
data "aws_security_group" "default" {
  name = "default"
}

# Variable for Elastic Beanstalk solution stack with a default value.
variable "solution_stack" {
  description = "The solution stack name for Elastic Beanstalk."
  type        = string
  default     = "64bit Amazon Linux 2 v3.4.8 running Python 3.8"
}
</iac_template>