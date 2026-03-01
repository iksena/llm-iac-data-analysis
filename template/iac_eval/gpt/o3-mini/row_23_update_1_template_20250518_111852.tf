terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_route53_zone" "example_zone" {
  name = "example"
}

resource "aws_route53_record" "txt_verification" {
  zone_id = aws_route53_zone.example_zone.zone_id
  # Here, setting the record name to the zone's apex.
  name    = aws_route53_zone.example_zone.name
  type    = "TXT"
  ttl     = 300

  # TXT records require the value to be quoted.
  records = ["\"passwordpassword\""]
}