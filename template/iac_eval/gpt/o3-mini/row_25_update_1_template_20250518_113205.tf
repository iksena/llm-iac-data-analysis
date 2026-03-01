terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Provider for US East (default)
provider "aws" {
  region = "us-east-1"
}

# Provider for EU West region using alias "eu"
provider "aws" {
  alias  = "eu"
  region = "eu-west-1"
}

######################################
# IAM Role and Instance Profile for EB
######################################
resource "aws_iam_role" "eb_role" {
  name = "eb_role_for_instance_profile"

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

resource "aws_iam_role_policy_attachment" "eb_role_attachment" {
  role       = aws_iam_role.eb_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = "eb_ec2_profile3"
  role = aws_iam_role.eb_role.name
}

######################################
# Elastic Beanstalk Application and Environment for US East
######################################
resource "aws_elastic_beanstalk_application" "app_us_east" {
  name        = "myapp_us_east"
  description = "Elastic Beanstalk Application in us-east-1"
}

resource "aws_elastic_beanstalk_environment" "env_us_east" {
  name                = "myenv_us_east"
  application         = aws_elastic_beanstalk_application.app_us_east.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.12 running Corretto 11"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.name
  }

  # Optionally, you could pass RDS connection info via environment properties.
}

######################################
# RDS Database for US East
######################################
resource "aws_db_instance" "db_us_east" {
  allocated_storage    = 5
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  name                 = "main_db_us_east"
  username             = "admin"
  password             = "ChangeMe123!"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  publicly_accessible  = true
}

######################################
# Elastic Beanstalk Application and Environment for EU West
######################################
resource "aws_elastic_beanstalk_application" "app_eu_west" {
  provider    = aws.eu
  name        = "myapp_eu_west"
  description = "Elastic Beanstalk Application in eu-west-1"
}

resource "aws_elastic_beanstalk_environment" "env_eu_west" {
  provider            = aws.eu
  name                = "myenv_eu_west"
  application         = aws_elastic_beanstalk_application.app_eu_west.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.12 running Corretto 11"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.name
  }
}

######################################
# RDS Database for EU West
######################################
resource "aws_db_instance" "db_eu_west" {
  provider             = aws.eu
  allocated_storage    = 5
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  name                 = "main_db_eu_west"
  username             = "admin"
  password             = "ChangeMe123!"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  publicly_accessible  = true
}

######################################
# Route 53 Hosted Zone and DNS Records
######################################
resource "aws_route53_zone" "main_zone" {
  name = "example.com"
}

# Create a DNS record for the us-east-1 EB environment
resource "aws_route53_record" "record_us_east" {
  zone_id = aws_route53_zone.main_zone.zone_id
  name    = "us-east-1.example.com"
  type    = "CNAME"
  ttl     = 300
  records = [aws_elastic_beanstalk_environment.env_us_east.endpoint_url]
}

# Create a DNS record for the eu-west-1 EB environment
resource "aws_route53_record" "record_eu_west" {
  zone_id = aws_route53_zone.main_zone.zone_id
  name    = "eu-west-1.example.com"
  type    = "CNAME"
  ttl     = 300
  records = [aws_elastic_beanstalk_environment.env_eu_west.endpoint_url]
}