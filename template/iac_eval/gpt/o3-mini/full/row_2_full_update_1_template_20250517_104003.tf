Below is a complete Terraform configuration that deploys an AWS Classic Elastic Load Balancer named "main" and a Route 53 Hosted Zone named "primary". In addition, a Route 53 Alias Record is created to point to the ELB’s DNS name. You can adjust the domain name as needed. 

<iac_template>
provider "aws" {
  region = "us-west-2"
}

# Data resource to get available AZs (using one AZ for the ELB)
data "aws_availability_zones" "available" {}

# Create hosted zone "primary" for your domain (change the domain name as needed)
resource "aws_route53_zone" "primary" {
  name    = "example.com."    # replace with your actual domain
  comment = "Primary hosted zone"
}

# Create a Classic Elastic Load Balancer named "main"
resource "aws_elb" "main" {
  name               = "main-elb"
  availability_zones = [data.aws_availability_zones.available.names[0]]

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:80/"
  }
}

# Create a Route 53 alias record pointing to the ELB
resource "aws_route53_record" "elb_alias" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "main"         # The record will be main.example.com
  type    = "A"

  alias {
    name                   = aws_elb.main.dns_name
    zone_id                = aws_elb.main.zone_id
    evaluate_target_health = true
  }
}
</iac_template>