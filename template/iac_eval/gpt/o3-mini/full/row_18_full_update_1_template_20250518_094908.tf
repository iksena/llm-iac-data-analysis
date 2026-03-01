Below is an explanation of the Terraform program and then the complete HCL configuration:

Description:
• The configuration starts by declaring the AWS provider in the us-east-1 region.
• A VPC is created with CIDR block 10.0.0.0/16 along with two public subnets (in availability zones us-east-1a and us-east-1b). An Internet Gateway is created and attached to the VPC along with a route table that directs 0.0.0.0/0 traffic to the gateway. The two subnets are associated with the route table.
• An RDS MySQL instance is provisioned for the application’s database. A DB subnet group is declared, using the two subnets, and a security group allows MySQL traffic (port 3306). Default credentials are supplied for demonstration purposes.
• For the Elastic Beanstalk environment, an Elastic Beanstalk Application and Environment are defined. The environment’s option settings reference the VPC and subnets so that the application will run within the created VPC. Also, an IAM role is defined for the EC2 instances in the EB environment (with the instance profile) so that the managed instances have the proper access. An additional service role is also created and attached so that Elastic Beanstalk itself can assume the necessary identity.
• Finally, all resources have their required dependencies declared so that the configuration is fully self-contained and deployable.

Below is the complete Terraform HCL configuration:

<iac_template>
provider "aws" {
  region = "us-east-1"
}

#-----------------------------
# VPC and Networking Resources
#-----------------------------
resource "aws_vpc" "web_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "web-app-vpc"
  }
}

resource "aws_internet_gateway" "web_igw" {
  vpc_id = aws_vpc.web_vpc.id
  tags = {
    Name = "web-app-igw"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.web_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "web-app-subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.web_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "web-app-subnet2"
  }
}

resource "aws_route_table" "web_rt" {
  vpc_id = aws_vpc.web_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web_igw.id
  }

  tags = {
    Name = "web-app-rt"
  }
}

resource "aws_route_table_association" "subnet1_assoc" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.web_rt.id
}

resource "aws_route_table_association" "subnet2_assoc" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.web_rt.id
}

#-----------------------------
# IAM Roles and Instance Profiles for Elastic Beanstalk
#-----------------------------

# IAM role for Elastic Beanstalk EC2 instances
resource "aws_iam_role" "eb_instance_role" {
  name = "web-app-eb-instance-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
          "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eb_instance_policy_attach" {
  role       = aws_iam_role.eb_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = "web-app-eb-instance-profile"
  role = aws_iam_role.eb_instance_role.name
}

# IAM role for the Elastic Beanstalk service
resource "aws_iam_role" "eb_service_role" {
  name = "web-app-eb-service-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
          "Service": "elasticbeanstalk.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eb_service_policy_attach" {
  role       = aws_iam_role.eb_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkService"
}

#-----------------------------
# RDS Resources
#-----------------------------

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "web-app-db-subnet-group"
  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  tags = {
    Name = "web-app-db-subnet-group"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "web-app-rds-sg"
  description = "Allow MySQL access"
  vpc_id      = aws_vpc.web_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
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
    Name = "web-app-rds-sg"
  }
}

resource "aws_db_instance" "web_rds" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = "webappdb"
  username             = "admin"
  password             = "password"
  parameter_group_name = "default.mysql8.0"
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot  = true
  publicly_accessible  = false
  tags = {
    Name = "web-app-rds-instance"
  }
}

#-----------------------------
# Elastic Beanstalk Application and Environment
#-----------------------------
resource "aws_elastic_beanstalk_application" "app" {
  name        = "web-app-application"
  description = "Elastic Beanstalk Application for the web app"
}

resource "aws_elastic_beanstalk_environment" "env" {
  name                = "web-app-env"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2 v5.4.4 running Node.js"

  setting {
    namespace  = "aws:ec2:vpc"
    name       = "VPCId"
    value      = aws_vpc.web_vpc.id
  }

  setting {
    namespace  = "aws:ec2:vpc"
    name       = "Subnets"
    value      = "${aws_subnet.subnet1.id},${aws_subnet.subnet2.id}"
  }

  setting {
    namespace  = "aws:ec2:vpc"
    name       = "ELBSubnets"
    value      = "${aws_subnet.subnet1.id},${aws_subnet.subnet2.id}"
  }

  setting {
    namespace  = "aws:autoscaling:launchconfiguration"
    name       = "IamInstanceProfile"
    value      = aws_iam_instance_profile.eb_instance_profile.name
  }

  setting {
    namespace  = "aws:elasticbeanstalk:environment"
    name       = "ServiceRole"
    value      = aws_iam_role.eb_service_role.arn
  }
  
  tags = {
    Name = "web-app-eb-environment"
  }
}
</iac_template>