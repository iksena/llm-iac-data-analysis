provider "aws" {
  region = "us-east-1"
}

# Data to lookup latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

###############################
# VPC and Networking Resources
###############################

resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main_vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main_igw"
  }
}

resource "aws_subnet" "blue_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "blue_subnet"
  }
}

resource "aws_subnet" "green_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "green_subnet"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_rt"
  }
}

resource "aws_route_table_association" "blue_association" {
  subnet_id      = aws_subnet.blue_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "green_association" {
  subnet_id      = aws_subnet.green_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

###############################
# IAM Role and Instance Profile
###############################

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eb_ec2_role" {
  name               = "eb_ec2_role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "eb_ec2_profile"
  role = aws_iam_role.eb_ec2_role.name
}

###############################
# Security Groups
###############################

# Security group for EC2 instances (blue/green)
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow HTTP inbound"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2_sg"
  }
}

# Security group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow MySQL access from EC2"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description      = "MySQL from EC2 instances"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = [aws_security_group.ec2_sg.id]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds_sg"
  }
}

###############################
# EC2 Instances for Blue & Green
###############################

resource "aws_instance" "blue" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.blue_subnet.id
  associate_public_ip_address = true
  security_groups        = [aws_security_group.ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.eb_ec2_profile.name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl enable httpd
              systemctl start httpd
              echo "Hello from BLUE environment" > /var/www/html/index.html
              EOF

  tags = {
    Name = "blue-instance"
    Env  = "blue"
  }
}

resource "aws_instance" "green" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.green_subnet.id
  associate_public_ip_address = true
  security_groups        = [aws_security_group.ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.eb_ec2_profile.name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl enable httpd
              systemctl start httpd
              echo "Hello from GREEN environment" > /var/www/html/index.html
              EOF

  tags = {
    Name = "green-instance"
    Env  = "green"
  }
}

###############################
# RDS: Shared Database
###############################

# Create a DB subnet group using both subnets
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "myapp_db_subnet_group"
  subnet_ids = [aws_subnet.blue_subnet.id, aws_subnet.green_subnet.id]

  tags = {
    Name = "myapp_db_subnet_group"
  }
}

resource "aws_db_instance" "myapp_db" {
  identifier              = "myapp-db-instance"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  name                    = "myapp_db"
  username                = "admin"
  password                = "password123"
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  skip_final_snapshot     = true
  publicly_accessible     = true

  tags = {
    Name = "myapp_db"
  }
}

###############################
# Route 53 Hosted Zone & DNS Records
###############################

# Create a Route53 hosted zone for example.com
resource "aws_route53_zone" "primary_zone" {
  name = "example.com"
}

# Health Check for Blue Environment
resource "aws_route53_health_check" "blue_health_check" {
  fqdn            = aws_instance.blue.public_dns
  port            = 80
  type            = "HTTP"
  resource_path   = "/"
  request_interval = 30
  failure_threshold = 3
  # Using the public IP ensures that the health check targets the blue instance.
  ip_address      = aws_instance.blue.public_ip
}

# Health Check for Green Environment
resource "aws_route53_health_check" "green_health_check" {
  fqdn            = aws_instance.green.public_dns
  port            = 80
  type            = "HTTP"
  resource_path   = "/"
  request_interval = 30
  failure_threshold = 3
  ip_address      = aws_instance.green.public_ip
}

# Route53 DNS Record for Blue environment (PRIMARY failover)
resource "aws_route53_record" "blue_record" {
  zone_id = aws_route53_zone.primary_zone.zone_id
  name    = "app.example.com"
  type    = "A"
  ttl     = 60

  records = [aws_instance.blue.public_ip]

  set_identifier = "blue"
  failover_routing_policy {
    type = "PRIMARY"
  }
  
  health_check_id = aws_route53_health_check.blue_health_check.id
}

# Route53 DNS Record for Green environment (SECONDARY/failover)
resource "aws_route53_record" "green_record" {
  zone_id = aws_route53_zone.primary_zone.zone_id
  name    = "app.example.com"
  type    = "A"
  ttl     = 60

  records = [aws_instance.green.public_ip]

  set_identifier = "green"
  failover_routing_policy {
    type = "SECONDARY"
  }
  
  health_check_id = aws_route53_health_check.green_health_check.id
}