To fulfill the business need, we will create an AWS Elastic Load Balancer (ELB) and a target group. The load balancer will be an Application Load Balancer (ALB) that distributes incoming application traffic across multiple targets, such as EC2 instances, in multiple Availability Zones. The target group will define the targets (e.g., EC2 instances) that the load balancer will route requests to. We will also configure a listener to forward traffic from the load balancer to the target group.

The Terraform configuration will include:
- An AWS provider configuration.
- An Application Load Balancer (ALB).
- A target group for the ALB.
- A listener to connect the ALB to the target group.

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"
}

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

resource "aws_lb" "app_lb" {
  name               = "app-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
}

resource "aws_lb_target_group" "app_tg" {
  name     = "app-target-group"
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
```
</iac_template>

This configuration sets up a basic ALB with a target group and a listener to route HTTP traffic. The load balancer is public-facing, allowing traffic from any IP address on port 80. The target group is set up to receive traffic on port 80 as well.