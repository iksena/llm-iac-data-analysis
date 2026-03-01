terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

# Create a Route 53 Hosted Zone
resource "aws_route53_zone" "primary_zone" {
  name = "example.com"
}

# Define a Route 53 Traffic Policy with a sample weighted routing rule
resource "aws_route53_traffic_policy" "example_policy" {
  name     = "example-policy"
  document = jsonencode({
    "AWSPolicyFormatVersion" = "1.0",
    "RecordType"             = "A",
    "Endpoints" = {
      "endpoint1" = {
        "Type"  = "value",
        "Value" = "192.0.2.44"
      },
      "endpoint2" = {
        "Type"  = "value",
        "Value" = "192.0.2.45"
      }
    },
    "Rules" = [
      {
        "RuleType" = "weighted",
        "Items" = [
          {
            "EndpointReference" = "endpoint1",
            "Weight"            = 50
          },
          {
            "EndpointReference" = "endpoint2",
            "Weight"            = 50
          }
        ]
      }
    ]
  })
}

# Create an instance of the Route 53 Traffic Policy and associate it with the hosted zone
resource "aws_route53_traffic_policy_instance" "policy_instance" {
  hosted_zone_id        = aws_route53_zone.primary_zone.zone_id
  name                  = "www.example.com"
  ttl                   = 60
  traffic_policy_id     = aws_route53_traffic_policy.example_policy.id
  traffic_policy_version = aws_route53_traffic_policy.example_policy.latest_version
}