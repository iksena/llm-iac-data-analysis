provider "aws" {
  region = "us-east-1"
}

# Variables
variable "domain_name" {
  description = "The domain name for the traffic policy"
  type        = string
  default     = "example.com"
}

# Create Route 53 Traffic Policy
resource "aws_route53_traffic_policy" "main" {
  name        = "geolocation-policy"
  comment     = "Geolocation based routing with failover"
  document    = jsonencode({
    AWSPolicyFormatVersion = "2015-10-01"
    RecordType            = "A"
    Endpoints             = {
      endpoint-us = {
        Type  = "value"
        Value = "203.0.113.1"
      }
      endpoint-eu = {
        Type  = "value"
        Value = "203.0.113.2"
      }
      endpoint-default = {
        Type  = "value"
        Value = "203.0.113.3"
      }
    }
    Rules                = {
      geo-rule = {
        RuleType = "geo"
        GeoProximityLocations = [
          {
            Region     = "NA"
            Endpoint   = "endpoint-us"
            Bias      = 0
          },
          {
            Region     = "EU"
            Endpoint   = "endpoint-eu"
            Bias      = 0
          }
        ]
        Primary   = {
          EndpointReference = "endpoint-default"
        }
      }
    }
    StartRule            = "geo-rule"
  })
}

# Create Route 53 Traffic Policy Instance
resource "aws_route53_traffic_policy_instance" "test" {
  name                   = "policy-instance"
  hosted_zone_id         = aws_route53_zone.main.zone_id
  traffic_policy_id      = aws_route53_traffic_policy.main.id
  traffic_policy_version = aws_route53_traffic_policy.main.version
  ttl                    = 300
}

# Create Route 53 Hosted Zone
resource "aws_route53_zone" "main" {
  name = var.domain_name
}

# IAM Role for Route 53 Traffic Policy
resource "aws_iam_role" "route53_traffic_policy" {
  name = "route53-traffic-policy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "route53.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for Route 53 Traffic Policy
resource "aws_iam_role_policy" "route53_traffic_policy" {
  name = "route53-traffic-policy-permissions"
  role = aws_iam_role.route53_traffic_policy.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "route53:CreateTrafficPolicy",
          "route53:UpdateTrafficPolicy",
          "route53:DeleteTrafficPolicy",
          "route53:CreateTrafficPolicyInstance",
          "route53:UpdateTrafficPolicyInstance",
          "route53:DeleteTrafficPolicyInstance"
        ]
        Resource = "*"
      }
    ]
  })
}