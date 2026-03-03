provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy the resources"
  type        = string
  default     = "us-east-1"
}

resource "aws_route53_zone" "example_zone" {
  name = "example53.com"
}

resource "aws_route53_record" "example_record" {
  zone_id = aws_route53_zone.example_zone.zone_id
  name    = "www"
  type    = "A"
  ttl     = 300

  records = ["192.0.2.44"]
}