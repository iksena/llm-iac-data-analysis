<iac_template>
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

###############################
# Providers Setup
###############################

# Default provider for US West (us-west-2)
provider "aws" {
  region = "us-west-2"
}

# Provider for EU Central (eu-central-1)
provider "aws" {
  alias  = "eu"
  region = "eu-central-1"
}

###############################
# IAM Role and Instance Profile
###############################

resource "aws_iam_role" "eb_role" {
  name = "eb_role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = "eb_instance_profile"
  role = aws_iam_role.eb_role.name
}

##############################################
# Elastic Beanstalk Application & Environment: US West
##############################################

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

  provider = aws
}

##############################################
# Elastic Beanstalk Application & Environment: EU Central
##############################################

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

  provider = aws.eu
}

##############################################
# Route 53 DNS Configuration
##############################################

# Create a public hosted zone for example.com
resource "aws_route53_zone" "primary" {
  name    = "example.com"
  comment = "Primary hosted zone for example.com managed by Terraform"
}

# Geolocation DNS record for North America (points to US West environment)
resource "aws_route53_record" "us_record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "app.example.com"
  type    = "CNAME"
  ttl     = 60
  records = [aws_elastic_beanstalk_environment.us_env.endpoint_url]

  set_identifier = "NA"

  geolocation_routing_policy {
    continent = "NA"
  }
}

# Geolocation DNS record for Europe (points to EU Central environment)
resource "aws_route53_record" "eu_record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "app.example.com"
  type    = "CNAME"
  ttl     = 60
  records = [aws_elastic_beanstalk_environment.eu_env.endpoint_url]

  set_identifier = "EU"

  geolocation_routing_policy {
    continent = "EU"
  }
}

# Default DNS record (if no geolocation match, points to US West environment)
resource "aws_route53_record" "default_record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "app.example.com"
  type    = "CNAME"
  ttl     = 60
  records = [aws_elastic_beanstalk_environment.us_env.endpoint_url]

  set_identifier = "DEFAULT"
  # The absence of a geolocation_routing_policy block makes this record the default.
}
</iac_template>