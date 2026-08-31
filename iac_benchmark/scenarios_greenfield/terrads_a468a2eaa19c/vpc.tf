#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

# create a 10.0.0.0/16 VPC, two 10.0.X.0/24 subnets, an internet gateway
# setup the subnet routing to route external traffic through the internet gateway
resource "aws_vpc" "vpc_id" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = tomap({
    "Name" = "eks-vpc-${var.customer_name}-${var.cluster_name}",
    "kubernetes.io/cluster/${var.customer_name}-${var.cluster_name}" =  "shared"
    }
  )
}

resource "aws_subnet" "public_subnet" {
  depends_on = [
    aws_vpc.vpc_id
  ]

  # VPC in which subnet has to be created!
  vpc_id            = aws_vpc.vpc_id.id
  
  # IP Range of this subnet
  cidr_block        = var.public_subnet_cidr
  
  # Data Center of this subnet.
  availability_zone = data.aws_availability_zones.available.names[0]
  
  # Enabling automatic public IP assignment on instance launch!
  map_public_ip_on_launch = true

  tags = tomap({
    "Name" = "eks-subnet-${var.customer_name}-${var.cluster_name}",
    "kubernetes.io/cluster/${var.customer_name}-${var.cluster_name}" = "shared",
    }
  )
}

resource "aws_subnet" "private_subnet" {
  depends_on = [
    aws_vpc.vpc_id,
    aws_subnet.public_subnet
  ]
  count = length(var.private_subnet_cidrs)
  
  # VPC in which subnet has to be created!
  vpc_id = aws_vpc.vpc_id.id
  
  # IP Range of this subnet
  cidr_block = var.private_subnet_cidrs[count.index]
  
  # Data Center of this subnet.
  availability_zone = data.aws_availability_zones.available.names[count.index]
  
  tags = tomap({
    "Name" = "eks-subnet-${var.customer_name}-${var.cluster_name}",
    "kubernetes.io/cluster/${var.customer_name}-${var.cluster_name}" = "shared",
    }
  )
}

resource "aws_internet_gateway" "gw_id" {
  depends_on = [
    aws_vpc.vpc_id,
    aws_subnet.public_subnet
  ]

  vpc_id = aws_vpc.vpc_id.id

  tags = {
    Name =  "eks-internetgateway-${var.customer_name}-${var.cluster_name}",
    "kubernetes.io/cluster/${var.customer_name}-${var.cluster_name}" = "shared",
  }
}

resource "aws_route_table" "public_route_table_id" {
  vpc_id = aws_vpc.vpc_id.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_id.id
  }
}

resource "aws_route_table_association" "public_route_table_association_id" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table_id.id
}

# Creating an Elastic IP for the NAT Gateway!
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

# Creating a NAT Gateway!
resource "aws_nat_gateway" "natgw_id" {
  depends_on = [
    aws_eip.nat_eip
  ]

  # Allocating the Elastic IP to the NAT Gateway!
  allocation_id = aws_eip.nat_eip.id
  
  # Associating it in the Public Subnet!
  subnet_id = aws_subnet.public_subnet.id
  tags = {
    Name =  "eks-natgateway-${var.customer_name}-${var.cluster_name}",
    "kubernetes.io/cluster/${var.customer_name}-${var.cluster_name}" = "shared",
  }
}

# Creating a Route Table for the Nat Gateway!
resource "aws_route_table" "private_route_table_id" {
  depends_on = [
    aws_nat_gateway.natgw_id
  ]

  vpc_id = aws_vpc.vpc_id.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw_id.id
  }
}

resource "aws_route_table_association" "private_route_table_association_id" {
  count = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table_id.id
}