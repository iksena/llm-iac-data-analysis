To fulfill the business need, we will create an AWS Elastic Load Balancer (ELB) that forwards traffic to a target group consisting of one or more EC2 instances. The configuration will include the following components:

1. **AWS Provider Configuration**: Set up the AWS provider with a specified region.
2. **VPC and Subnets**: Create a Virtual Private Cloud (VPC) and subnets to host the load balancer and instances.
3. **Security Group**: Define a security group to allow HTTP traffic to the load balancer.
4. **EC2 Instances**: Launch EC2 instances that will be part of the target group.
5. **Target Group**: Create a target group to register the EC2 instances.
6. **Load Balancer**: Set up an Application Load Balancer (ALB) to distribute incoming traffic to the target group.

The following Terraform HCL template will implement this infrastructure:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
}

data "aws_availability_zones" "available" {}

resource "aws_security_group" "lb_sg" {
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

resource "aws_instance" "app" {
  count         = 2
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  subnet_id     = element(aws_subnet.main[*].id, count.index)

  tags = {
    Name = "AppInstance-${count.index}"
  }
}

resource "aws_lb" "app_lb" {
  name               = "app-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.main[*].id
}

resource "aws_lb_target_group" "app_tg" {
  name     = "app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "app_tg_attachment" {
  count            = 2
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = element(aws_instance.app[*].id, count.index)
  port             = 80
}

resource "aws_lb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
```
</iac_template>

This configuration sets up a basic infrastructure with an Application Load Balancer that forwards HTTP traffic to a target group of EC2 instances within a VPC. The instances are distributed across two availability zones for high availability.