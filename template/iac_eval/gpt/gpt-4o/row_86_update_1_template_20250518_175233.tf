provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "route53_policy_role" {
  name = "Route53PolicyRole"

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

resource "aws_iam_role_policy" "route53_policy" {
  name   = "Route53Policy"
  role   = aws_iam_role.route53_policy_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "route53:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_route53_zone" "example" {
  name = "example.com"
}

resource "aws_route53_traffic_policy" "example_policy" {
  name = "example-policy"
  document = jsonencode({
    Version = "2015-04-01"
    StartRule = "example-rule"
    Endpoints = {
      "example-endpoint" = {
        Type = "value"
        Value = "192.0.2.44"
      }
    }
    Rules = {
      "example-rule" = {
        Type = "simple"
        EndpointReference = "example-endpoint"
      }
    }
  })
}

resource "aws_route53_traffic_policy_instance" "example_instance" {
  hosted_zone_id = aws_route53_zone.example.zone_id
  name           = "www.example.com"
  ttl            = 60
  traffic_policy_id = aws_route53_traffic_policy.example_policy.id
  traffic_policy_version = aws_route53_traffic_policy.example_policy.version
}