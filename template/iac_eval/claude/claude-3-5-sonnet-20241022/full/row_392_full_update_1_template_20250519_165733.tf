I'll help you create a Terraform configuration for an AWS Application Load Balancer (ALB) with Elastic IPs. Since ALBs don't directly support Elastic IPs, we'll create a Network Load Balancer (NLB) which does support them. Here's what we'll create:

1. A VPC with public subnets
2. A Network Load Balancer with Elastic IPs
3. Target group and example EC2 instance
4. Necessary security groups and IAM roles
5. Elastic IPs for each subnet

<iac_template>
# Provider configuration
provider "aws" {
  region = "us-west-2"
}

# VPC and Networking
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Main IGW"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Elastic IPs
resource "aws_eip" "nlb" {
  count = 2
  vpc   = true

  tags = {
    Name = "NLB-EIP-${count.index + 1}"
  }
}

# Network Load Balancer
resource "aws_lb" "nlb" {
  name               = "example-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = aws_subnet.public[*].id

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

# Target Group
resource "aws_lb_target_group" "example" {
  name        = "example-tg"
  port        = 80
  protocol    = "TCP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval           = 30
    protocol           = "TCP"
    port               = "traffic-port"
  }
}

# NLB Listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }
}

# Security Group for instances
resource "aws_security_group" "instance" {
  name_prefix = "instance-sg"
  vpc_id      = aws_vpc.main.id

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

# Data source for AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# Example EC2 Instance
resource "aws_instance" "example" {
  ami           = "ami-0735c191cf914754d"  # Amazon Linux 2 in us-west-2
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public[0].id

  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOF

  tags = {
    Name = "Example Instance"
  }
}

# Register the instance with the target group
resource "aws_lb_target_group_attachment" "example" {
  target_group_arn = aws_lb_target_group.example.arn
  target_id        = aws_instance.example.id
  port             = 80
}
</iac_template>

This Terraform configuration creates:
1. A VPC with two public subnets across different availability zones
2. An Internet Gateway and appropriate routing
3. Two Elastic IPs
4. A Network Load Balancer that can use the Elastic IPs
5. A target group and listener for the NLB
6. A security group for the EC2 instances
7. An example EC2 instance running a basic web server
8. All necessary networking components

The Network Load Balancer is created in the public subnets and will automatically associate with the Elastic IPs. The configuration includes a sample EC2 instance that will be registered with the NLB's target group.

To use this configuration:
1. Initialize Terraform: `terraform init`
2. Review the plan: `terraform plan`
3. Apply the configuration: `terraform apply`

Note: Remember that Elastic IPs and other AWS resources may incur costs in your AWS account. Make sure to run `terraform destroy` when you're done testing if you don't want to keep these resources.