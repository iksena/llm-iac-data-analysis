I'll help you create a Terraform configuration that sets up an AWS VPC with the specified networking components, two Elastic Beanstalk environments, and a shared RDS database.

Description:
This Terraform configuration will:
1. Create a VPC with CIDR block 10.0.0.0/16
2. Create an Internet Gateway and attach it to the VPC
3. Create two public subnets in different availability zones
4. Create a route table for public subnets with internet access
5. Create a security group for Elastic Beanstalk environments
6. Create an RDS subnet group using the public subnets
7. Create a shared RDS database instance
8. Create two Elastic Beanstalk environments with necessary IAM roles

Here's the complete Terraform configuration:

<iac_template>
provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "eb_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "eb_vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "eb_igw" {
  vpc_id = aws_vpc.eb_vpc.id

  tags = {
    Name = "eb_igw"
  }
}

# Public Subnets
resource "aws_subnet" "eb_subnet_public_1" {
  vpc_id            = aws_vpc.eb_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "eb_subnet_public_1"
  }
}

resource "aws_subnet" "eb_subnet_public_2" {
  vpc_id            = aws_vpc.eb_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "eb_subnet_public_2"
  }
}

# Route Table
resource "aws_route_table" "eb_public_rt" {
  vpc_id = aws_vpc.eb_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eb_igw.id
  }

  tags = {
    Name = "eb_public_rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.eb_subnet_public_1.id
  route_table_id = aws_route_table.eb_public_rt.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.eb_subnet_public_2.id
  route_table_id = aws_route_table.eb_public_rt.id
}

# Security Group
resource "aws_security_group" "eb_env_sg" {
  name        = "eb_env_sg"
  description = "Security group for Elastic Beanstalk environments"
  vpc_id      = aws_vpc.eb_vpc.id

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

# RDS Subnet Group
resource "aws_db_subnet_group" "eb_rds_subnet_group" {
  name       = "eb-rds-subnet-group"
  subnet_ids = [aws_subnet.eb_subnet_public_1.id, aws_subnet.eb_subnet_public_2.id]

  tags = {
    Name = "EB RDS subnet group"
  }
}

# RDS Instance
resource "aws_db_instance" "shared_rds" {
  identifier           = "shared-rds"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  username            = "admin"
  password            = "password123!" # Change this in production
  skip_final_snapshot = true

  db_subnet_group_name   = aws_db_subnet_group.eb_rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.eb_env_sg.id]
}

# IAM Role for Elastic Beanstalk
resource "aws_iam_role" "eb_service_role" {
  name = "eb-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "elasticbeanstalk.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eb_service" {
  role       = aws_iam_role.eb_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

# Elastic Beanstalk Applications
resource "aws_elastic_beanstalk_application" "eb_app_1" {
  name = "eb-app-1"
}

resource "aws_elastic_beanstalk_application" "eb_app_2" {
  name = "eb-app-2"
}

# Elastic Beanstalk Environments
resource "aws_elastic_beanstalk_environment" "eb_env_1" {
  name                = "eb-env-1"
  application         = aws_elastic_beanstalk_application.eb_app_1.name
  solution_stack_name = "64bit Amazon Linux 2 v5.6.4 running Node.js 18"
  service_role        = aws_iam_role.eb_service_role.arn

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.eb_vpc.id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${aws_subnet.eb_subnet_public_1.id},${aws_subnet.eb_subnet_public_2.id}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.eb_env_sg.id
  }
}

resource "aws_elastic_beanstalk_environment" "eb_env_2" {
  name                = "eb-env-2"
  application         = aws_elastic_beanstalk_application.eb_app_2.name
  solution_stack_name = "64bit Amazon Linux 2 v5.6.4 running Node.js 18"
  service_role        = aws_iam_role.eb_service_role.arn

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.eb_vpc.id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${aws_subnet.eb_subnet_public_1.id},${aws_subnet.eb_subnet_public_2.id}"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.eb_env_sg.id
  }
}
</iac_template>

This configuration creates all the required resources and connects them appropriately. A few important notes:

1. The VPC is created with DNS support enabled
2. The public subnets are placed in different availability zones for high availability
3. The security group allows inbound HTTP and HTTPS traffic
4. The RDS instance is created with basic settings (modify as needed for production)
5. The Elastic Beanstalk environments are configured with Node.js platform (modify as needed)
6. Proper IAM roles are created for Elastic Beanstalk service
7. All resources are properly tagged and named as requested

Remember to:
- Change the RDS password for production use
- Adjust the RDS instance size and storage as needed
- Modify the Elastic Beanstalk solution stack name based on your application requirements
- Add additional security group rules if needed
- Consider adding private subnets for better security in production