Below is a description of the Terraform program:

• The configuration defines the AWS provider for region “us-west-2”.
• It creates an IAM role and instance profile for Elastic Beanstalk EC2 instances. The instance profile is explicitly named “eb_ec2_profile” to meet the requirement.
• A relational database instance (“default”) is provisioned using aws_db_instance with MySQL as its engine.
• An Elastic Beanstalk application and an environment are created. The environment is configured with option settings to (a) use the custom instance profile for EC2 instances and (b) set environment variables with the connection details of the RDS database.
• All necessary default parameter values (such as DB credentials) and dependencies are declared so that the configuration is deployable.

Below is the complete Terraform HCL configuration:

<iac_template>
provider "aws" {
  region = "us-west-2"
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

resource "aws_db_instance" "default" {
  identifier           = "default"
  allocated_storage    = 5
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydatabase"
  username             = "admin"
  password             = "password"
  skip_final_snapshot  = true
  publicly_accessible  = true
}

resource "aws_elastic_beanstalk_application" "app" {
  name = "my-eb-app"
}

resource "aws_elastic_beanstalk_environment" "env" {
  name                = "my-eb-env"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2 v5.4.6 running Corretto 11"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_ec2_profile.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_HOSTNAME"
    value     = aws_db_instance.default.address
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_PORT"
    value     = aws_db_instance.default.port
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_DB_NAME"
    value     = aws_db_instance.default.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_USERNAME"
    value     = aws_db_instance.default.username
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_PASSWORD"
    value     = aws_db_instance.default.password
  }

  depends_on = [aws_db_instance.default]
}
</iac_template>