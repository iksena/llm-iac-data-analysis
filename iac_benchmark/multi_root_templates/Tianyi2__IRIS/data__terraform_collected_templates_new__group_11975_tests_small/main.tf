terraform {
  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

############################
# Providers
############################
provider "aws" {
  region = var.aws_region
}

############################
# Variables (including a sensitive one)
############################
variable "aws_region" {
  type        = string
  description = "AWS region to deploy into"
  default     = "us-east-1"
}

variable "project" {
  type        = string
  description = "Project name used as a prefix for resources"
}

variable "db_password" {
  type        = string
  description = "Database password (kept secret)"
  sensitive   = true
}

############################
# Data source
############################

data "aws_ssm_parameter" "password" {
  name = "secret"
}

############################
# Module call
############################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">= 5.0.0"

  name = "${var.project}-vpc"
  cidr = "10.0.0.0/16"
}

############################
# Resource example
############################
resource "aws_s3_bucket" "artifact" {
  bucket = "${var.project}-artifact-bucket"

  tags = {
    Project = var.project
  }
}

############################
# Outputs
############################
output "vpc_id" {
  description = "ID of the VPC created by the module"
  value       = module.vpc.vpc_id
}

output "artifact_bucket_id" {
  description = "ID of the S3 bucket for artifacts"
  value       = aws_s3_bucket.artifact.id
}

output "sensitive_variable_example" {
  description = "Demonstrates a sensitive output (will be redacted on CLI)"
  value       = var.db_password
  sensitive   = true
}

