Description:
This Terraform configuration sets up an AWS Route 53 hosted zone named "example.com" (called "primary" in the resource name) and an Elastic Load Balancer (ELB) named "main". The ELB is configured with a simple HTTP listener on port 80 and a basic health check, and it is deployed in a single availability zone. A Route 53 record is created in the hosted zone pointing to the ELB using an alias record. Default variables are provided for the AWS region, the availability zone, and the domain name used for the zone.

<iac_template>
provider "aws" {
  region = var.region
}

variable "region" {
  description = "The AWS region to deploy resources."
  type        = string
  default     = "us-west-2"
}

variable "availability_zone" {
  description = "The AWS availability zone to deploy the ELB."
  type        = string
  default     = "us-west-2a"
}

variable "zone_domain" {
  description = "The domain name for the Route 53 hosted zone."
  type        = string
  default     = "example.com"
}

resource "aws_route53_zone" "primary" {
  name = var.zone_domain
}

resource "aws_elb" "main" {
  name               = "main"
  availability_zones = [var.availability_zone]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  instances = []  // No instances attached; this ELB is configured standalone.
}

resource "aws_route53_record" "main_record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "main"
  type    = "A"

  alias {
    name                   = aws_elb.main.dns_name
    zone_id                = aws_elb.main.zone_id
    evaluate_target_health = true
  }
}
</iac_template>