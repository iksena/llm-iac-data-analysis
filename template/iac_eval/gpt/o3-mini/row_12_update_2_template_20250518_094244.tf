terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region to deploy resources."
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "The domain name for the Route53 Hosted Zone."
  type        = string
  default     = "example.com"
}

variable "subdomain" {
  description = "The subdomain for application routing."
  type        = string
  default     = "app"
}

variable "blue_weight" {
  description = "Weight (percentage) for the blue environment."
  type        = number
  default     = 50
}

variable "green_weight" {
  description = "Weight (percentage) for the green environment."
  type        = number
  default     = 50
}

# Create an Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "blue_green_app" {
  name        = "blue-green-app"
  description = "Application for Blue/Green deployments using Elastic Beanstalk"
}

# Create a basic configuration template for the application
resource "aws_elastic_beanstalk_configuration_template" "blue_green_config" {
  name                = "blue-green-config"
  application         = aws_elastic_beanstalk_application.blue_green_app.name
  solution_stack_name = "64bit Amazon Linux 2 v5.5.0 running Node.js 14"
}

# Create the Blue environment
resource "aws_elastic_beanstalk_environment" "blue" {
  name                = "blue"
  application         = aws_elastic_beanstalk_application.blue_green_app.name
  solution_stack_name = "64bit Amazon Linux 2 v5.5.0 running Node.js 14"
  template_name       = aws_elastic_beanstalk_configuration_template.blue_green_config.name

  # Additional configuration can be provided in option_settings if required.
}

# Create the Green environment
resource "aws_elastic_beanstalk_environment" "green" {
  name                = "green"
  application         = aws_elastic_beanstalk_application.blue_green_app.name
  solution_stack_name = "64bit Amazon Linux 2 v5.5.0 running Node.js 14"
  template_name       = aws_elastic_beanstalk_configuration_template.blue_green_config.name
}

# Create a Route53 Hosted Zone for the domain
resource "aws_route53_zone" "primary" {
  name = var.domain_name
}

# Create the weighted DNS record for the Blue environment
resource "aws_route53_record" "blue_record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "${var.subdomain}.${var.domain_name}"
  type    = "CNAME"
  ttl     = 60

  records = [aws_elastic_beanstalk_environment.blue.cname]

  set_identifier = "blue"
  weighted_routing_policy {
    weight = var.blue_weight
  }
}

# Create the weighted DNS record for the Green environment
resource "aws_route53_record" "green_record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "${var.subdomain}.${var.domain_name}"
  type    = "CNAME"
  ttl     = 60

  records = [aws_elastic_beanstalk_environment.green.cname]

  set_identifier = "green"
  weighted_routing_policy {
    weight = var.green_weight
  }
}