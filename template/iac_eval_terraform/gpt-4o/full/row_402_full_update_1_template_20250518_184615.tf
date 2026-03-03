To fulfill the business need, we will create a Terraform configuration that sets up an AWS Elastic Load Balancer (ELB) with an IP Target Group. This configuration will include the necessary IAM roles, security groups, and the load balancer itself. The load balancer will be set up in a specified AWS region, and the target group will be configured to route traffic to specified IP addresses.

The configuration will include:
1. AWS provider configuration.
2. A security group to allow traffic to the load balancer.
3. An Elastic Load Balancer (ELB).
4. An IP Target Group associated with the ELB.
5. Necessary IAM roles and policies.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "lb_sg" {
  name        = "lb_security_group"
  description = "Security group for the load balancer"

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

resource "aws_lb" "example" {
  name               = "example-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = ["subnet-0123456789abcdef0", "subnet-0fedcba9876543210"] # Replace with your subnet IDs

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "example" {
  name     = "example-targets"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-0123456789abcdef0" # Replace with your VPC ID

  target_type = "ip"

  health_check {
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "example" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }
}

resource "aws_lb_target_group_attachment" "example" {
  target_group_arn = aws_lb_target_group.example.arn
  target_id        = "10.0.1.10" # Replace with your target IP address
  port             = 80
}
```
</iac_template>

This configuration sets up an Application Load Balancer (ALB) with a security group that allows HTTP traffic on port 80. The target group is configured to route traffic to IP addresses within the specified VPC. Make sure to replace the placeholder subnet IDs, VPC ID, and target IP address with your actual network details.