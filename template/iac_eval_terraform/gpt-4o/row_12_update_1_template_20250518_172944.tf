provider "aws" {
  region = "us-east-1"
}

resource "aws_elastic_beanstalk_application" "example" {
  name        = "example-app"
  description = "Example Elastic Beanstalk Application"
}

resource "aws_elastic_beanstalk_environment" "blue" {
  name                = "blue"
  application         = aws_elastic_beanstalk_application.example.name
  solution_stack_name = "64bit Amazon Linux 2 v5.4.4 running Node.js 14"
}

resource "aws_elastic_beanstalk_environment" "green" {
  name                = "green"
  application         = aws_elastic_beanstalk_application.example.name
  solution_stack_name = "64bit Amazon Linux 2 v5.4.4 running Node.js 14"
}

resource "aws_route53_zone" "example" {
  name = "example.com"
}

resource "aws_route53_record" "blue" {
  zone_id = aws_route53_zone.example.zone_id
  name    = "blue.example.com"
  type    = "CNAME"
  ttl     = 60
  records = [aws_elastic_beanstalk_environment.blue.endpoint_url]

  set_identifier = "blue"
  weight         = 50
}

resource "aws_route53_record" "green" {
  zone_id = aws_route53_zone.example.zone_id
  name    = "green.example.com"
  type    = "CNAME"
  ttl     = 60
  records = [aws_elastic_beanstalk_environment.green.endpoint_url]

  set_identifier = "green"
  weight         = 50
}

resource "aws_route53_record" "weighted" {
  zone_id = aws_route53_zone.example.zone_id
  name    = "example.com"
  type    = "CNAME"
  ttl     = 60

  weighted_routing_policy {
    weight = 50
  }

  alias {
    name                   = aws_route53_record.blue.fqdn
    zone_id                = aws_route53_zone.example.zone_id
    evaluate_target_health = false
  }

  weighted_routing_policy {
    weight = 50
  }

  alias {
    name                   = aws_route53_record.green.fqdn
    zone_id                = aws_route53_zone.example.zone_id
    evaluate_target_health = false
  }
}