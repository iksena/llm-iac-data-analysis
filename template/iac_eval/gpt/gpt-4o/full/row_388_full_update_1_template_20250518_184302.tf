To fulfill the business need, we will create a Terraform configuration that sets up an AWS Network Load Balancer (NLB) and attaches it to an EC2 instance of type `t2.micro`. The configuration will include the following components:

1. **AWS Provider Configuration**: Set up the AWS provider to interact with AWS services in a specified region.
2. **VPC and Subnet**: Create a Virtual Private Cloud (VPC) and a public subnet where the EC2 instance will reside.
3. **Security Group**: Define a security group to allow necessary inbound and outbound traffic.
4. **EC2 Instance**: Launch an EC2 instance of type `t2.micro` within the created subnet.
5. **Elastic IP**: Allocate an Elastic IP for the EC2 instance.
6. **Network Load Balancer**: Create a Network Load Balancer and attach it to the EC2 instance.

The following Terraform HCL script will implement this infrastructure:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "allow_http" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  security_groups = [aws_security_group.allow_http.name]

  tags = {
    Name = "WebServer"
  }
}

resource "aws_eip" "web" {
  instance = aws_instance.web.id
  vpc      = true
}

resource "aws_lb" "nlb" {
  name               = "nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.public.id]

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "tg" {
  name     = "tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "web" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.web.id
  port             = 80
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
```
</iac_template>

This configuration will create a basic setup with a Network Load Balancer distributing traffic to a single EC2 instance. The instance is publicly accessible via HTTP on port 80.