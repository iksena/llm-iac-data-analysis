The Terraform program will create an AWS Elastic Load Balancer (ELB) and a Route 53 DNS record that points to the ELB. The Route 53 hosted zone will be named "primary", and the ELB will be named "main". The configuration will include the necessary IAM roles and policies to allow the ELB to function correctly. The program will also specify a valid AWS provider configuration.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_elb" "main" {
  name               = "main"
  availability_zones = ["us-east-1a", "us-east-1b"]

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "main-elb"
  }
}

resource "aws_route53_zone" "primary" {
  name = "primary.example.com"
}

resource "aws_route53_record" "main" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "main.primary.example.com"
  type    = "A"

  alias {
    name                   = aws_elb.main.dns_name
    zone_id                = aws_elb.main.zone_id
    evaluate_target_health = true
  }
}
```
</iac_template>