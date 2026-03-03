Below is the description of the Terraform program that will be created:

Description:
• This Terraform configuration provisions an AWS Elastic Beanstalk Application and two Elastic Beanstalk Environments named "blue" and "green". Both environments use a common Elastic Beanstalk Application for deployment.
• A Route53 Hosted Zone is created for the domain "example.com". Then, two Route53 record resources are created for the subdomain "app.example.com". These records use a Weighted Routing Policy (each with a weight of 50) so that traffic can be directed between the "blue" and "green" environments.
• A valid AWS provider configuration (using us-east-1 as the region) is included along with default values in any variables.
• No undeclared resources remain and all require resources (IAM roles, if needed by Elastic Beanstalk, are provisioned by AWS automatically via the service).

Below is the complete Terraform HCL template:

<iac_template>
provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "The domain name used for Route53 Hosted Zone"
  type        = string
  default     = "example.com"
}

variable "subdomain" {
  description = "The subdomain for application routing"
  type        = string
  default     = "app"
}

variable "blue_weight" {
  description = "Weight for blue environment in weighted routing"
  type        = number
  default     = 50
}

variable "green_weight" {
  description = "Weight for green environment in weighted routing"
  type        = number
  default     = 50
}

# Create the Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "blue_green_app" {
  name        = "blue-green-app"
  description = "Application for Blue/Green deployments using Elastic Beanstalk"
}

# Create a basic configuration template for the application
resource "aws_elastic_beanstalk_configuration_template" "blue_green_config" {
  name                = "blue-green-config"
  application         = aws_elastic_beanstalk_application.blue_green_app.name
  solution_stack_name = "64bit Amazon Linux 2 v5.5.0 running Node.js 14"

  # Optionally, you can add settings here as needed
}

# Create the Blue environment
resource "aws_elastic_beanstalk_environment" "blue" {
  name                = "blue"
  application         = aws_elastic_beanstalk_application.blue_green_app.name
  solution_stack_name = "64bit Amazon Linux 2 v5.5.0 running Node.js 14"
  # Either use configuration template or supply option_settings if more customization is required:
  template_name       = aws_elastic_beanstalk_configuration_template.blue_green_config.name

  # Optionally, add settings (option_settings block) if needed for the environment
}

# Create the Green environment
resource "aws_elastic_beanstalk_environment" "green" {
  name                = "green"
  application         = aws_elastic_beanstalk_application.blue_green_app.name
  solution_stack_name = "64bit Amazon Linux 2 v5.5.0 running Node.js 14"
  template_name       = aws_elastic_beanstalk_configuration_template.blue_green_config.name

  # Optionally, add settings (option_settings block) if needed for the environment
}

# Create a Route53 Hosted Zone for the domain
resource "aws_route53_zone" "primary" {
  name = var.domain_name
}

# Create the weighted DNS record for Blue environment
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

# Create the weighted DNS record for Green environment
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
</iac_template>