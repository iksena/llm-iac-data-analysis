provider "aws" {
  region  = "us-west-2"
}

variable "cidr_block_prefix" {
  description = "cidr block for the vpc"
  default     = "10.0.0.0/16"
}

variable "subnet_prefix" {
  description = "cidr block for the subnets"
  default = [
    { cidr_block = "10.0.0.0/24", az = "us-west-2a", name = "subnet-0" },
    { cidr_block = "10.0.1.0/24", az = "us-west-2b", name = "subnet-1" },
    { cidr_block = "10.0.2.0/24", az = "us-west-2c", name = "subnet-2" },
    { cidr_block = "10.0.3.0/24", az = "us-west-2a", name = "subnet-3" },
    { cidr_block = "10.0.4.0/24", az = "us-west-2b", name = "subnet-4" },
    { cidr_block = "10.0.5.0/24", az = "us-west-2c", name = "subnet-5" },
    { cidr_block = "10.0.6.0/24", az = "us-west-2a", name = "subnet-6" },
    { cidr_block = "10.0.7.0/24", az = "us-west-2b", name = "subnet-7" },
    { cidr_block = "10.0.8.0/24", az = "us-west-2c", name = "subnet-8" },
    { cidr_block = "10.0.9.0/24", az = "us-west-2a", name = "subnet-9" },
    { cidr_block = "10.0.10.0/24", az = "us-west-2b", name = "subnet-10" },
    { cidr_block = "10.0.11.0/24", az = "us-west-2c", name = "subnet-11" },
    { cidr_block = "10.0.12.0/24", az = "us-west-2a", name = "subnet-12" },
    { cidr_block = "10.0.13.0/24", az = "us-west-2b", name = "subnet-13" },
    { cidr_block = "10.0.14.0/24", az = "us-west-2c", name = "subnet-14" },
    { cidr_block = "10.0.15.0/24", az = "us-west-2a", name = "subnet-15" },
  ]
}

#Create AWS VPC
resource "aws_vpc" "vpc-deploy-me" {
  cidr_block       = var.cidr_block_prefix
  instance_tenancy = "default"
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "my-deploy-me-vpc"
  }
}

#Create AWS VPC Internet gateway
resource "aws_internet_gateway" "igw-deploy-me" {
  vpc_id = aws_vpc.vpc-deploy-me.id

  tags = {
    Name = "igw-deploy-me"
  }
}

#AWS Elastic IP
resource "aws_eip" "eip-deploy-me-for-nat" {
  domain                    = "vpc"
  depends_on                = [aws_internet_gateway.igw-deploy-me]
}

#Printig Outputs 
output "server_public_ip" {
  value = aws_eip.eip-deploy-me-for-nat.public_ip
}

#NAT Gateway
resource "aws_nat_gateway" "deployme-natgw" {
  allocation_id = aws_eip.eip-deploy-me-for-nat.id
  subnet_id     = aws_subnet.sn-deployme-private-1a.id
  depends_on = [aws_internet_gateway.igw-deploy-me]

  tags = {
    Name = "deployme-natgw"
  }
}

#Subnet Group 1
#Create AWS VPC Private Subnet A us-west-2a
resource "aws_subnet" "sn-deployme-private-1a" {
  vpc_id            = aws_vpc.vpc-deploy-me.id
  cidr_block        = var.subnet_prefix[0].cidr_block
  availability_zone = var.subnet_prefix[0].az

  tags = {
    Name = var.subnet_prefix[0].name
  }
}

#Create AWS VPC Private Subnet A us-west-2b
resource "aws_subnet" "sn-deployme-private-2a" {
  vpc_id            = aws_vpc.vpc-deploy-me.id
  cidr_block        = var.subnet_prefix[1].cidr_block
  availability_zone = var.subnet_prefix[1].az

  tags = {
    Name = var.subnet_prefix[1].name
  }
}

#Create AWS VPC Private Subnet A us-west-2c
resource "aws_subnet" "sn-deployme-private-3a" {
  vpc_id            = aws_vpc.vpc-deploy-me.id
  cidr_block        = var.subnet_prefix[2].cidr_block
  availability_zone = var.subnet_prefix[2].az

  tags = {
    Name = var.subnet_prefix[2].name
  }
}

#Create AWS VPC Private Subnet A us-west-2d
resource "aws_subnet" "sn-deployme-private-4a" {
  vpc_id            = aws_vpc.vpc-deploy-me.id
  cidr_block        = var.subnet_prefix[3].cidr_block
  availability_zone = var.subnet_prefix[3].az

  tags = {
    Name = var.subnet_prefix[3].name
  }
}

#Subnet Group 2
#Create AWS VPC Private Subnet B us-west-2a
resource "aws_subnet" "sn-deployme-private-1b" {
  vpc_id            = aws_vpc.vpc-deploy-me.id
  cidr_block        = var.subnet_prefix[8].cidr_block
  availability_zone = var.subnet_prefix[8].az

  tags = {
    Name = var.subnet_prefix[8].name
  }
}

#Create AWS VPC Private Subnet B us-west-2b
resource "aws_subnet" "sn-deployme-private-2b" {
  vpc_id            = aws_vpc.vpc-deploy-me.id
  cidr_block        = var.subnet_prefix[9].cidr_block
  availability_zone = var.subnet_prefix[9].az

  tags = {
    Name = var.subnet_prefix[9].name
  }
}

#Create AWS VPC Private Subnet B us-west-2c
resource "aws_subnet" "sn-deployme-private-3b" {
  vpc_id            = aws_vpc.vpc-deploy-me.id
  cidr_block        = var.subnet_prefix[10].cidr_block
  availability_zone = var.subnet_prefix[10].az

  tags = {
    Name = var.subnet_prefix[10].name
  }
}

#Create AWS VPC Private Subnet B us-west-2d
resource "aws_subnet" "sn-deployme-private-4b" {
  vpc_id            = aws_vpc.vpc-deploy-me.id
  cidr_block        = var.subnet_prefix[11].cidr_block
  availability_zone = var.subnet_prefix[11].az

  tags = {
    Name = var.subnet_prefix[11].name
  }
}

#Create AWS VPC Private Main Route table
resource "aws_route_table" "rt-private-deploy-me" {

  vpc_id = aws_vpc.vpc-deploy-me.id

  route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.deployme-natgw.id
  }

  tags = {
    Name = "rt-private-deploy-me"
  }
}

#Associate SUbnet With Private A Route Table
resource "aws_route_table_association" "rta-private-associate-1" {
  subnet_id      = aws_subnet.sn-deployme-private-1a.id
  route_table_id = aws_route_table.rt-private-deploy-me.id
}

resource "aws_route_table_association" "rta-private-associate-2" {
  subnet_id      = aws_subnet.sn-deployme-private-2a.id
  route_table_id = aws_route_table.rt-private-deploy-me.id
}

resource "aws_route_table_association" "rta-private-associate-3" {
  subnet_id      = aws_subnet.sn-deployme-private-3a.id
  route_table_id = aws_route_table.rt-private-deploy-me.id
}

resource "aws_route_table_association" "rta-private-associate-4" {
  subnet_id      = aws_subnet.sn-deployme-private-4a.id
  route_table_id = aws_route_table.rt-private-deploy-me.id
}

#Associate SUbnet With Private B Route Table
resource "aws_route_table_association" "rtb-private-associate-1" {
  subnet_id      = aws_subnet.sn-deployme-private-1b.id
  route_table_id = aws_route_table.rt-private-deploy-me.id
}

resource "aws_route_table_association" "rtb-private-associate-2" {
  subnet_id      = aws_subnet.sn-deployme-private-2b.id
  route_table_id = aws_route_table.rt-private-deploy-me.id
}

resource "aws_route_table_association" "rtb-private-associate-3" {
  subnet_id      = aws_subnet.sn-deployme-private-3b.id
  route_table_id = aws_route_table.rt-private-deploy-me.id
}

resource "aws_route_table_association" "rtb-private-associate-4" {
  subnet_id      = aws_subnet.sn-deployme-private-4b.id
  route_table_id = aws_route_table.rt-private-deploy-me.id
}

# Main Route Table Association
resource "aws_main_route_table_association" "rt-associate-main" {
  vpc_id         = aws_vpc.vpc-deploy-me.id
  route_table_id = aws_route_table.rt-private-deploy-me.id
}

#Subnet Group 3
#Create AWS VPC Public Subnet us-west-2a
resource "aws_subnet" "sn-deployme-public-1" {
  vpc_id            = aws_vpc.vpc-deploy-me.id
  cidr_block        = var.subnet_prefix[4].cidr_block
  availability_zone = var.subnet_prefix[4].az
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet_prefix[4].name
  }
}

#Create AWS VPC Public Subnet  us-west-2b
resource "aws_subnet" "sn-deployme-public-2" {
  vpc_id            = aws_vpc.vpc-deploy-me.id
  cidr_block        = var.subnet_prefix[5].cidr_block
  availability_zone = var.subnet_prefix[5].az
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet_prefix[5].name
  }
}

#Create AWS VPC Public Subnet us-west-2c
resource "aws_subnet" "sn-deployme-public-3" {
  vpc_id            = aws_vpc.vpc-deploy-me.id
  cidr_block        = var.subnet_prefix[6].cidr_block
  availability_zone = var.subnet_prefix[6].az
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet_prefix[6].name
  }
}

#Create AWS VPC Public Subnet  us-west-2d
resource "aws_subnet" "sn-deployme-public-4" {
  vpc_id            = aws_vpc.vpc-deploy-me.id
  cidr_block        = var.subnet_prefix[7].cidr_block
  availability_zone = var.subnet_prefix[7].az
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet_prefix[7].name
  }
}

#Create AWS VPC Public Route table
resource "aws_route_table" "rt-public-deploy-me" {

  vpc_id = aws_vpc.vpc-deploy-me.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-deploy-me.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.igw-deploy-me.id
  }

  tags = {
    Name = "rt-public-deploy-me"
  }
}

#Associate SUbnet With Public Route Table
resource "aws_route_table_association" "rt-public-associate-1" {
  subnet_id      = aws_subnet.sn-deployme-public-1.id
  route_table_id = aws_route_table.rt-public-deploy-me.id
}

resource "aws_route_table_association" "rt-public-associate-2" {
  subnet_id      = aws_subnet.sn-deployme-public-2.id
  route_table_id = aws_route_table.rt-public-deploy-me.id
}

resource "aws_route_table_association" "rt-public-associate-3" {
  subnet_id      = aws_subnet.sn-deployme-public-3.id
  route_table_id = aws_route_table.rt-public-deploy-me.id
}

resource "aws_route_table_association" "rt-public-associate-4" {
  subnet_id      = aws_subnet.sn-deployme-public-4.id
  route_table_id = aws_route_table.rt-public-deploy-me.id
}

#Subnet Group 4
#Create AWS VPC Spare Subnet us-west-2a
resource "aws_subnet" "sn-deployme-spare-1" {
  vpc_id            = aws_vpc.vpc-deploy-me.id
  cidr_block        = var.subnet_prefix[12].cidr_block
  availability_zone = var.subnet_prefix[12].az

  tags = {
    Name = var.subnet_prefix[12].name
  }
}

#Create AWS VPC Spare Subnet  us-west-2b
resource "aws_subnet" "sn-deployme-spare-2" {
  vpc_id            = aws_vpc.vpc-deploy-me.id
  cidr_block        = var.subnet_prefix[13].cidr_block
  availability_zone = var.subnet_prefix[13].az

  tags = {
    Name = var.subnet_prefix[13].name
  }
}

#Create AWS VPC Spare Subnet us-west-2c
resource "aws_subnet" "sn-deployme-spare-3" {
  vpc_id            = aws_vpc.vpc-deploy-me.id
  cidr_block        = var.subnet_prefix[14].cidr_block
  availability_zone = var.subnet_prefix[14].az

  tags = {
    Name = var.subnet_prefix[14].name
  }
}

#Create AWS VPC Spare Subnet  us-west-2d
resource "aws_subnet" "sn-deployme-spare-4" {
  vpc_id            = aws_vpc.vpc-deploy-me.id
  cidr_block        = var.subnet_prefix[15].cidr_block
  availability_zone = var.subnet_prefix[15].az

  tags = {
    Name = var.subnet_prefix[15].name
  }
}

#Create AWS VPC Spare Route table
resource "aws_route_table" "rt-spare-deploy-me" {

  vpc_id = aws_vpc.vpc-deploy-me.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-deploy-me.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.igw-deploy-me.id
  }

  tags = {
    Name = "rt-spare-deploy-me"
  }
}

#Associate SUbnet With Private B Route Table
resource "aws_route_table_association" "rt-spare-associate-1" {
  subnet_id      = aws_subnet.sn-deployme-spare-1.id
  route_table_id = aws_route_table.rt-spare-deploy-me.id
}

resource "aws_route_table_association" "rt-spare-associate-2" {
  subnet_id      = aws_subnet.sn-deployme-spare-2.id
  route_table_id = aws_route_table.rt-spare-deploy-me.id
}

resource "aws_route_table_association" "rt-spare-associate-3" {
  subnet_id      = aws_subnet.sn-deployme-spare-3.id
  route_table_id = aws_route_table.rt-spare-deploy-me.id
}

resource "aws_route_table_association" "rt-spare-associate-4" {
  subnet_id      = aws_subnet.sn-deployme-spare-4.id
  route_table_id = aws_route_table.rt-spare-deploy-me.id
}

#Create a Security Group
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web Traffic"
  vpc_id      = aws_vpc.vpc-deploy-me.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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
    Name = "allow_web_traffic"
  }
}
