Below is a brief description of the Terraform program followed by the complete HCL program:

Description:
This Terraform program deploys an AWS Elastic Beanstalk application with an associated environment. It sets up the AWS provider within a specified region (defaulting to us-west-2) and defines variables for the application name, environment name, and solution stack name. The configuration creates an Elastic Beanstalk application using the resource aws_elastic_beanstalk_application and an associated environment using aws_elastic_beanstalk_environment. All variables include default values so that the configuration is deployable with minimal adjustments.

<iac_template>
provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy resources into."
  type        = string
  default     = "us-west-2"
}

variable "application_name" {
  description = "The name for the Elastic Beanstalk application."
  type        = string
  default     = "sample-eb-app"
}

variable "environment_name" {
  description = "The name for the Elastic Beanstalk environment."
  type        = string
  default     = "sample-eb-env"
}

variable "solution_stack_name" {
  description = "The solution stack name for Elastic Beanstalk environment."
  type        = string
  # This example uses a Python stack on Amazon Linux 2. Adjust as needed.
  default     = "64bit Amazon Linux 2 v3.4.10 running Python 3.8"
}

resource "aws_elastic_beanstalk_application" "beanstalk_app" {
  name        = var.application_name
  description = "Elastic Beanstalk application deployed using Terraform"
}

resource "aws_elastic_beanstalk_environment" "beanstalk_env" {
  name                = var.environment_name
  application         = aws_elastic_beanstalk_application.beanstalk_app.name
  solution_stack_name = var.solution_stack_name

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }
}
</iac_template>