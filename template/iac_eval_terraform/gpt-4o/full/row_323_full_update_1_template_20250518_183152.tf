The Terraform program will create an AWS Virtual Private Cloud (VPC) with a CIDR block of "10.0.0.0/16". Within this VPC, three subnets will be created with CIDR blocks "10.0.4.0/24", "10.0.5.0/24", and "10.0.6.0/24". A security group will be configured to allow inbound traffic from the VPC IP range on port 80 using TCP, and outbound traffic to any IP on port 80 using TCP. An Application Load Balancer (ALB) will be set up, associated with the security group and the three subnets. A target group will be created for the ALB, listening on port 80 with the HTTP protocol. A listener will be configured to forward traffic to the target group. An EC2 instance running the latest Ubuntu will be attached to the target group. Additionally, a Route53 hosted zone will be created for the domain "test-video-stream.com", with alias records pointing to the ALB for both IPv4 and IPv6, evaluating target health.

```hcl
<iac_template>
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"
}

resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.5.0/24"
}

resource "aws_subnet" "subnet3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.6.0/24"
}

resource "aws_security_group" "lb_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id, aws_subnet.subnet3.id]
}

resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet1.id

  tags = {
    Name = "web-instance"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_lb_target_group_attachment" "web_attachment" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.web.id
  port             = 80
}

resource "aws_route53_zone" "main" {
  name = "test-video-stream.com"
}

resource "aws_route53_record" "lb_ipv4" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "lb.test-video-stream.com"
  type    = "A"

  alias {
    name                   = aws_lb.app_lb.dns_name
    zone_id                = aws_lb.app_lb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "lb_ipv6" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "lb.test-video-stream.com"
  type    = "AAAA"

  alias {
    name                   = aws_lb.app_lb.dns_name
    zone_id                = aws_lb.app_lb.zone_id
    evaluate_target_health = true
  }
}
</iac_template>
```