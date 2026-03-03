To create a Gateway Load Balancer using Terraform, we will set up the necessary AWS infrastructure. This includes defining a VPC, subnets, an Elastic IP, and the Gateway Load Balancer itself. The Gateway Load Balancer will be associated with a target group, and we will also create a listener for the load balancer. Additionally, we will configure the necessary IAM roles and security groups to ensure proper access and functionality.

Below is the Terraform HCL configuration to achieve this setup:

<iac_template>

```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "subnet2"
  }
}

resource "aws_eip" "gwlb" {
  vpc = true
}

resource "aws_lb" "gwlb" {
  name               = "gateway-load-balancer"
  internal           = false
  load_balancer_type = "gateway"
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  enable_deletion_protection = false

  tags = {
    Name = "gateway-load-balancer"
  }
}

resource "aws_lb_target_group" "gwlb_tg" {
  name     = "gwlb-target-group"
  port     = 80
  protocol = "GENEVE"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled             = true
    interval            = 30
    protocol            = "GENEVE"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 10
  }

  tags = {
    Name = "gwlb-target-group"
  }
}

resource "aws_lb_listener" "gwlb_listener" {
  load_balancer_arn = aws_lb.gwlb.arn
  port              = 6081
  protocol          = "GENEVE"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gwlb_tg.arn
  }
}

resource "aws_security_group" "gwlb_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 6081
    to_port     = 6081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "gwlb-security-group"
  }
}
```

</iac_template>

This configuration sets up a Gateway Load Balancer in the AWS region `us-west-2`, with the necessary subnets, target group, and listener. The security group allows traffic on the GENEVE protocol port (6081) from any source.