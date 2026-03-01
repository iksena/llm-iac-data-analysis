terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Provider for US West region (default)
provider "aws" {
  region = "us-west-2"
}

# Provider for EU Central region
provider "aws" {
  alias  = "eu"
  region = "eu-central-1"
}

# Create an IAM role for Elastic Beanstalk (for EC2 instances)
resource "aws_iam_role" "eb_role" {
  name = "eb_role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action    = "sts:AssumeRole"
    }]
  })
}

# Create an IAM instance profile for Elastic Beanstalk
resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = "eb_instance_profile"
  role = aws_iam_role.eb_role.name
}

# Elastic Beanstalk Application and Environment in US West
resource "aws_elastic_beanstalk_application" "us_app" {
  name        = "app_us_west"
  description = "Elastic Beanstalk application in US West region"
}

resource "aws_elastic_beanstalk_environment" "us_env" {
  name                = "us_west"
  application         = aws_elastic_beanstalk_application.us_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.6 running Python 3.8"
  
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.name
  }
  
  # Ensure this resource is created in US West
  provider = aws
}

# Elastic Beanstalk Application and Environment in EU Central
resource "aws_elastic_beanstalk_application" "eu_app" {
  name        = "app_eu_central"
  description = "Elastic Beanstalk application in EU Central region"
  
  provider = aws.eu
}

resource "aws_elastic_beanstalk_environment" "eu_env" {
  name                = "eu_central"
  application         = aws_elastic_beanstalk_application.eu_app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.6 running Python 3.8"
  
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.name
  }
  
  # Ensure this resource is created in EU Central
  provider = aws.eu
}

# Route53 Public Hosted Zone for example.com
resource "aws_route53_zone" "primary" {
  name    = "example.com"
  comment = "Primary hosted zone for example.com managed by Terraform"
}

# Route53 geolocation records for app.example.com
# Record for North America (US West environment)
resource "aws_route53_record" "us_record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "app.example.com"
  type    = "CNAME"
  ttl     = 60
  records = [aws_elastic_beanstalk_environment.us_env.endpoint_url]

  set_identifier = "NA"
  geolocation {
    continent = "NA"
  }
}

# Record for Europe (EU Central environment)
resource "aws_route53_record" "eu_record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "app.example.com"
  type    = "CNAME"
  ttl     = 60
  records = [aws_elastic_beanstalk_environment.eu_env.endpoint_url]

  set_identifier = "EU"
  geolocation {
    continent = "EU"
  }
}

# Default record for clients that do not match any geolocation (points to US West)
resource "aws_route53_record" "default_record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "app.example.com"
  type    = "CNAME"
  ttl     = 60
  records = [aws_elastic_beanstalk_environment.us_env.endpoint_url]

  set_identifier = "DEFAULT"
  # No geolocation block makes this the default answer.
}