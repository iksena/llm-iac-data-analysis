The Terraform program will create an AWS Virtual Private Cloud (VPC) named "eb_vpc" with an internet gateway, two public subnets named "eb_subnet_public_1" and "eb_subnet_public_2", a security group named "eb_env_sg", and a route table associated with the public subnets. It will also set up two Elastic Beanstalk environments connected to this VPC and a shared RDS database named "shared_rds" linked to the subnets. The security group will allow necessary traffic for the Elastic Beanstalk environments and the RDS database.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "eb_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "eb_vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eb_vpc.id
}

resource "aws_subnet" "eb_subnet_public_1" {
  vpc_id            = aws_vpc.eb_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
    Name = "eb_subnet_public_1"
  }
}

resource "aws_subnet" "eb_subnet_public_2" {
  vpc_id            = aws_vpc.eb_vpc.id
  cidr_block        = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"
  tags = {
    Name = "eb_subnet_public_2"
  }
}

resource "aws_security_group" "eb_env_sg" {
  vpc_id = aws_vpc.eb_vpc.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "eb_env_sg"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.eb_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.eb_subnet_public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.eb_subnet_public_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_db_subnet_group" "shared_rds_subnet_group" {
  name       = "shared_rds_subnet_group"
  subnet_ids = [aws_subnet.eb_subnet_public_1.id, aws_subnet.eb_subnet_public_2.id]
}

resource "aws_db_instance" "shared_rds" {
  identifier              = "shared-rds"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t2.micro"
  name                    = "shared_rds"
  username                = "admin"
  password                = "password123"
  db_subnet_group_name    = aws_db_subnet_group.shared_rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.eb_env_sg.id]
  skip_final_snapshot     = true
}

resource "aws_elastic_beanstalk_application" "app" {
  name = "my-app"
}

resource "aws_elastic_beanstalk_environment" "env1" {
  name                = "env1"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.6 running Python 3.8"
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.eb_env_sg.id
  }
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
}

resource "aws_elastic_beanstalk_environment" "env2" {
  name                = "env2"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.6 running Python 3.8"
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.eb_env_sg.id
  }
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
}
```
</iac_template>