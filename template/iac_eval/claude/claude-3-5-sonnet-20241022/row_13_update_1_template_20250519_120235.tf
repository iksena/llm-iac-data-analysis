providers for different regions
provider "aws" {
  alias  = "us_west"
  region = "us-west-2"
}

provider "aws" {
  alias  = "eu_central"
  region = "eu-central-1"
}

# Main provider for Route53 resources
provider "aws" {
  region = "us-west-2"
}

# Variables
variable "application_name" {
  default = "my-geo-app"
}

variable "domain_name" {
  default = "example.com"
}

# IAM Role for Elastic Beanstalk
resource "aws_iam_role" "beanstalk_service" {
  name = "beanstalk-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "elasticbeanstalk.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Role for EC2 instances
resource "aws_iam_role" "beanstalk_ec2" {
  name = "beanstalk-ec2-role"

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

# Attach policies to roles
resource "aws_iam_role_policy_attachment" "beanstalk_service" {
  role       = aws_iam_role.beanstalk_service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

resource "aws_iam_role_policy_attachment" "beanstalk_web_tier" {
  role       = aws_iam_role.beanstalk_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

# Create instance profile
resource "aws_iam_instance_profile" "beanstalk_ec2" {
  name = "beanstalk-ec2-instance-profile"
  role = aws_iam_role.beanstalk_ec2.name
}

# US West Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "us_west" {
  provider = aws.us_west
  name     = "${var.application_name}-us-west"
}

# EU Central Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "eu_central" {
  provider = aws.eu_central
  name     = "${var.application_name}-eu-central"
}

# US West Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "us_west" {
  provider    = aws.us_west
  name        = "us-west"
  application = aws_elastic_beanstalk_application.us_west.name
  
  solution_stack_name = "64bit Amazon Linux 2 v5.6.4 running Node.js 18"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk_ec2.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.beanstalk_service.name
  }
}

# EU Central Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "eu_central" {
  provider    = aws.eu_central
  name        = "eu-central"
  application = aws_elastic_beanstalk_application.eu_central.name
  
  solution_stack_name = "64bit Amazon Linux 2 v5.6.4 running Node.js 18"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk_ec2.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.beanstalk_service.name
  }
}

# Route53 Hosted Zone
resource "aws_route53_zone" "main" {
  name = var.domain_name
}

# Route53 Record for US traffic
resource "aws_route53_record" "us_west" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  geolocation_routing_policy {
    country = "US"
  }

  alias {
    name                   = aws_elastic_beanstalk_environment.us_west.cname
    zone_id                = aws_route53_zone.main.zone_id
    evaluate_target_health = true
  }

  set_identifier = "us-west"
}

# Route53 Record for EU traffic
resource "aws_route53_record" "eu_central" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  geolocation_routing_policy {
    continent = "EU"
  }

  alias {
    name                   = aws_elastic_beanstalk_environment.eu_central.cname
    zone_id                = aws_route53_zone.main.zone_id
    evaluate_target_health = true
  }

  set_identifier = "eu-central"
}

# Default Route53 Record (fallback)
resource "aws_route53_record" "default" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  geolocation_routing_policy {
    country = "*"
  }

  alias {
    name                   = aws_elastic_beanstalk_environment.us_west.cname
    zone_id                = aws_route53_zone.main.zone_id
    evaluate_target_health = true
  }

  set_identifier = "default"
}