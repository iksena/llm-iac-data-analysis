provider "aws" {
  region = "us-east-1"
}

# Variables
variable "domain_name" {
  default = "example.com"
}

variable "environment_name" {
  default = "myapp"
}

# VPC and Networking
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public Subnet 1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Public Subnet 2"
  }
}

# Security Groups
resource "aws_security_group" "eb_sg" {
  name        = "eb-security-group"
  description = "Security group for Elastic Beanstalk"
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

resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Security group for RDS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.eb_sg.id]
  }
}

# IAM Role and Instance Profile
resource "aws_iam_role" "eb_role" {
  name = "eb_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eb_policy" {
  role       = aws_iam_role.eb_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_instance_profile" "eb_ec2_profile" {
  name = "eb_ec2_profile"
  role = aws_iam_role.eb_role.name
}

# RDS Instance
resource "aws_db_instance" "myapp_db" {
  identifier           = "myapp-db"
  allocated_storage    = 20
  storage_type        = "gp2"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  username            = "admin"
  password            = "password123"
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.public1.id, aws_subnet.public2.id]
}

# Elastic Beanstalk Environments
resource "aws_elastic_beanstalk_application" "myapp" {
  name = var.environment_name
}

resource "aws_elastic_beanstalk_environment" "blue" {
  name                = "${var.environment_name}-blue"
  application         = aws_elastic_beanstalk_application.myapp.name
  solution_stack_name = "64bit Amazon Linux 2 v5.6.1 running Node.js 18"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_ec2_profile.name
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.main.id
  }
}

resource "aws_elastic_beanstalk_environment" "green" {
  name                = "${var.environment_name}-green"
  application         = aws_elastic_beanstalk_application.myapp.name
  solution_stack_name = "64bit Amazon Linux 2 v5.6.1 running Node.js 18"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_ec2_profile.name
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.main.id
  }
}

# Route 53 Health Checks
resource "aws_route53_health_check" "blue" {
  fqdn              = aws_elastic_beanstalk_environment.blue.cname
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name = "blue-health-check"
  }
}

resource "aws_route53_health_check" "green" {
  fqdn              = aws_elastic_beanstalk_environment.green.cname
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name = "green-health-check"
  }
}

# Route 53 Records
resource "aws_route53_zone" "primary" {
  name = var.domain_name
}

resource "aws_route53_record" "blue" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "blue.${var.domain_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_elastic_beanstalk_environment.blue.cname]

  failover_routing_policy {
    type = "PRIMARY"
  }

  set_identifier = "blue"
  health_check_id = aws_route53_health_check.blue.id
}

resource "aws_route53_record" "green" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "green.${var.domain_name}"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_elastic_beanstalk_environment.green.cname]

  failover_routing_policy {
    type = "SECONDARY"
  }

  set_identifier = "green"
  health_check_id = aws_route53_health_check.green.id
}