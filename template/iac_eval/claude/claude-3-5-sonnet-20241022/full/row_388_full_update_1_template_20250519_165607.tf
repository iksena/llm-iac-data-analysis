I'll help you create a Terraform configuration that sets up a Network Load Balancer (NLB) attached to an EC2 instance of type t2.micro in AWS. This configuration will include:

1. A VPC with a public subnet
2. An EC2 instance of type t2.micro
3. A Network Load Balancer
4. Required security groups
5. Target group for the NLB
6. Necessary IAM roles and networking components

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main"
  }
}

# Create Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

# Create Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Create Security Group for EC2
resource "aws_security_group" "ec2" {
  name        = "ec2-security-group"
  description = "Security group for EC2 instance"
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

# Create EC2 Instance
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id

  vpc_security_group_ids = [aws_security_group.ec2.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from EC2</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "web-server"
  }
}

# Create Target Group
resource "aws_lb_target_group" "web" {
  name     = "web-target-group"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id

  health_check {
    protocol = "TCP"
    port     = "traffic-port"
  }
}

# Attach EC2 to Target Group
resource "aws_lb_target_group_attachment" "web" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = aws_instance.web.id
  port             = 80
}

# Create Network Load Balancer
resource "aws_lb" "web" {
  name               = "web-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.public.id]

  tags = {
    Name = "web-nlb"
  }
}

# Create NLB Listener
resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

# Output the NLB DNS name
output "nlb_dns_name" {
  description = "DNS name of the Network Load Balancer"
  value       = aws_lb.web.dns_name
}
</iac_template>

This Terraform configuration creates:
1. A VPC with a public subnet and internet gateway
2. An EC2 instance of type t2.micro running a simple web server
3. A Network Load Balancer in the public subnet
4. A target group that includes the EC2 instance
5. Necessary security groups and routing configurations

The EC2 instance runs a basic Apache web server, and the NLB forwards TCP traffic on port 80 to the instance. The configuration outputs the DNS name of the Network Load Balancer, which you can use to access the web server.

To use this configuration:
1. Make sure you have AWS credentials configured
2. Initialize Terraform: `terraform init`
3. Review the plan: `terraform plan`
4. Apply the configuration: `terraform apply`

Note: Remember to run `terraform destroy` when you want to clean up the resources to avoid unnecessary charges.