To build the infrastructure for a video streaming site with load balancing, we will create a Virtual Private Cloud (VPC) using the AWS VPC module. Within this VPC, we will deploy multiple EC2 instances to serve as the backend servers for the video streaming application. An Elastic Load Balancer (ELB) will be used to distribute incoming traffic across these EC2 instances. Additionally, we will configure Route 53 to manage DNS records for the site, ensuring that traffic is directed to the load balancer. We will also create necessary IAM roles and security groups to ensure secure and efficient operation of the infrastructure.

<iac_template>

```hcl
provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = "video-streaming-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

resource "aws_security_group" "elb_sg" {
  name        = "elb-security-group"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-security-group"
  description = "Allow traffic from ELB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.elb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  count         = 3
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  subnet_id     = element(module.vpc.private_subnets, count.index)
  security_groups = [aws_security_group.ec2_sg.name]

  tags = {
    Name = "web-instance-${count.index}"
  }
}

resource "aws_elb" "web" {
  name               = "video-streaming-elb"
  security_groups    = [aws_security_group.elb_sg.id]
  subnets            = module.vpc.public_subnets

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

  instances = aws_instance.web[*].id

  tags = {
    Name = "video-streaming-elb"
  }
}

resource "aws_route53_zone" "main" {
  name = "example.com"
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www"
  type    = "A"

  alias {
    name                   = aws_elb.web.dns_name
    zone_id                = aws_elb.web.zone_id
    evaluate_target_health = true
  }
}
```

</iac_template>

This configuration sets up a VPC with public and private subnets, deploys EC2 instances in the private subnets, and configures an ELB to balance traffic across these instances. Route 53 is used to manage DNS records, directing traffic to the ELB. Security groups are configured to allow necessary traffic between the ELB and EC2 instances.