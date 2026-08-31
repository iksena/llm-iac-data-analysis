



terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region     = "${var.region}"
}

resource "aws_vpc" "my_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Terraform = "true"
    Name = "VPC_from_Terraform"
  }
}


resource "aws_security_group" "terraform" {
  name        = "allow_ssh_http_https"
  description = "Allow SSH HTTP HTTPS inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id


  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.my_vpc.cidr_block]

  }


  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }


  ingress {
    description      = "HTTPS from VPC"
    from_port        = 443
    to_port          = 443
protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  tags = {
    Name = "Terraform_SG_HTTP_HTTPS_SSH"
  }
}

######

resource "aws_subnet" "Terraform_private_subnet" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

}


#########################
resource "aws_instance" "instance" {
  count = "${var.number_of_instances}"
  ami           = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  subnet_id     = aws_subnet.Terraform_private_subnet[count.index].id

  root_block_device {

        volume_size = "${var.vol_size}"
        tags = {
          Name = "Terraform_EBS_Volume1"
          }
        }

  vpc_security_group_ids = [aws_security_group.terraform.id]

  tags = {
    Name = "Terraform_Instance"
  }
}


# To configure Auto Scaling you need to have a launch template/configuration

# resource "aws_launch_configuration" "ASG_LT" {
 #  name_prefix     = "ASG_Launch_Template"
 #  image_id        = "${var.ami_id}"
 #  instance_type   = "${var.instance_type}"
 #  root_block_device {

  #       volume_size = "${var.vol_size}"

  #       }

# security_groups = [aws_security_group.terraform.id]

#   lifecycle {
#     create_before_destroy = true
 #  }
# }

# Now we will configure the ASG and call the Launch template


# resource "aws_autoscaling_group" "ASG" {
#  count = length(var.private_subnet_cidr_blocks)
 # min_size             = 1
 # max_size             = 3
#  desired_capacity     = 1
#  launch_configuration = aws_launch_configuration.ASG_LT.name
 # vpc_zone_identifier  = [aws_subnet.Terraform_private_subnet[1].id]

#}

/*
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

resource "aws_route_table" "private" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id = aws_vpc.default.id
}

resource "aws_route" "private" {
  count = length(var.private_subnet_cidr_blocks)

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.default[count.index].id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}


resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr_blocks)

  vpc_id                  = aws_vpc.default.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr_blocks)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr_blocks)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


# NAT resources: This will create 2 NAT gateways in 2 Public Subnets for 2 different Private Subnets.

resource "aws_eip" "nat" {
  count = length(var.public_subnet_cidr_blocks)

  vpc = true
}

resource "aws_nat_gateway" "default" {
  depends_on = ["aws_internet_gateway.default"]

  count = length(var.public_subnet_cidr_blocks)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
}

*/





