Below is a description of the Terraform program followed by the complete HCL code.

Description:
• The configuration uses the AWS provider in the us-west-2 region.
• It creates an IAM role and instance profile named "eb_ec2_profile1" for use by the Elastic Beanstalk environment.
• It defines an Elastic Beanstalk application and environment. The environment is named "myenv", is configured with a common Amazon Linux 2 solution stack, and is linked to the instance profile.
• It provisions an RDS MySQL database instance with identifier "myapp_db". In order to keep the configuration self-contained the DB is configured with default username "admin", password "password", and a database name "myapp_db". A security group (“rds_sg”) is defined to allow inbound MySQL access.
• Option settings are added in the Elastic Beanstalk environment to pass along RDS connection details (hostname, port, database name, username and password) so that the application can use them.
• Finally a Route 53 hosted zone is created for the domain “example.com” and a CNAME record named “www” is created that directs traffic to the Elastic Beanstalk environment’s endpoint.

Below is the complete deployable Terraform HCL configuration:

<iac_template>
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

###############################################################################
# IAM Role and Instance Profile for Elastic Beanstalk EC2 Instances
###############################################################################
resource "aws_iam_role" "eb_role" {
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

resource "aws_iam_role_policy_attachment" "eb_role_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
  role       = aws_iam_role.eb_role.name
}

resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = "eb_ec2_profile1"
  role = aws_iam_role.eb_role.name
}

###############################################################################
# Elastic Beanstalk Application and Environment
###############################################################################
resource "aws_elastic_beanstalk_application" "eb_app" {
  name        = "myenv-app"
  description = "Elastic Beanstalk Application for myenv"
}

# Create the Elastic Beanstalk environment, associating it with the instance profile
resource "aws_elastic_beanstalk_environment" "eb_env" {
  name                = "myenv"
  application         = aws_elastic_beanstalk_application.eb_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.6 running Python 3.8"

  setting {
    namespace  = "aws:autoscaling:launchconfiguration"
    name       = "IamInstanceProfile"
    value      = aws_iam_instance_profile.eb_instance_profile.name
  }

  # Pass RDS connection information as environment variables (populated after RDS creation)
  setting {
    namespace  = "aws:elasticbeanstalk:application:environment"
    name       = "RDS_HOSTNAME"
    value      = aws_db_instance.myapp_db.address
  }

  setting {
    namespace  = "aws:elasticbeanstalk:application:environment"
    name       = "RDS_PORT"
    value      = tostring(aws_db_instance.myapp_db.port)
  }

  setting {
    namespace  = "aws:elasticbeanstalk:application:environment"
    name       = "RDS_DB_NAME"
    value      = aws_db_instance.myapp_db.name
  }

  setting {
    namespace  = "aws:elasticbeanstalk:application:environment"
    name       = "RDS_USERNAME"
    value      = var.db_username
  }

  setting {
    namespace  = "aws:elasticbeanstalk:application:environment"
    name       = "RDS_PASSWORD"
    value      = var.db_password
  }

  depends_on = [aws_db_instance.myapp_db]
}

###############################################################################
# RDS Database (MySQL)
###############################################################################
resource "aws_security_group" "rds_sg" {
  name        = "rds_security_group"
  description = "Allow MySQL inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_db_instance" "myapp_db" {
  identifier              = "myapp-db-instance"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t2.micro"
  name                    = "myapp_db"
  username                = var.db_username
  password                = var.db_password
  parameter_group_name    = "default.mysql8.0"
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  publicly_accessible     = true
}

###############################################################################
# Route 53 Hosted Zone and Record
###############################################################################
resource "aws_route53_zone" "primary" {
  name = var.domain_name
}

resource "aws_route53_record" "eb_record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = 300

  records = [aws_elastic_beanstalk_environment.eb_env.endpoint_url]
}

###############################################################################
# Variables
###############################################################################
variable "domain_name" {
  description = "The domain name for the Route53 hosted zone"
  type        = string
  default     = "example.com"
}

variable "db_username" {
  description = "Database admin user name"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database admin password"
  type        = string
  default     = "password"
}
</iac_template>