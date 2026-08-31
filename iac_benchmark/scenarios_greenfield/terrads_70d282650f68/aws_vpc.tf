/*
 * VPC
 */
resource "aws_vpc" "main-vpc" {
    cidr_block           = "${var.aws_vpc_cidr}"
    instance_tenancy     = "default"
    enable_dns_support   = "true"
    enable_dns_hostnames = "false"
    tags = {
      Name = "${var.app_name}-vpc"
    }
}

/*
 * InternetGateway
 */
resource "aws_internet_gateway" "public-igw" {
    vpc_id = "${aws_vpc.main-vpc.id}"
    tags = {
      Name = "${var.app_name}-public-igw"
    }
}

/*
 * PublicSubnet
 */
resource "aws_subnet" "main-publicsubnet-1" {
    vpc_id            = "${aws_vpc.main-vpc.id}"
    cidr_block        = "${var.public_subnet_cidrs.1}"
    availability_zone = "${var.availability_zones.1}"
    tags = {
        Name = "${var.app_name}-public-subnet-1"
    }
}
resource "aws_subnet" "main-publicsubnet-2" {
    vpc_id            = "${aws_vpc.main-vpc.id}"
    cidr_block        = "${var.public_subnet_cidrs.2}"
    availability_zone = "${var.availability_zones.2}"
    tags = {
        Name = "${var.app_name}-public-subnet-2"
    }
}

/*
 * PrivateSubnet
 */
resource "aws_subnet" "main-privatesubnet-1" {
    vpc_id            = "${aws_vpc.main-vpc.id}"
    cidr_block        = "${var.private_subnet_cidrs.1}"
    availability_zone = "${var.availability_zones.1}"
    tags = {
        Name = "${var.app_name}-private-subnet-1"
    }
}
resource "aws_subnet" "main-privatesubnet-2" {
    vpc_id            = "${aws_vpc.main-vpc.id}"
    cidr_block        = "${var.private_subnet_cidrs.2}"
    availability_zone = "${var.availability_zones.2}"
    tags = {
        Name = "${var.app_name}-private-subnet-2"
    }
}

/*
 * NatGateway
 */
resource "aws_eip" "nat" {
    domain = "vpc"
}
resource "aws_nat_gateway" "main-ngw" {
    allocation_id = "${aws_eip.nat.id}"
    subnet_id     = "${aws_subnet.main-publicsubnet-1.id}"
}

/*
 * RouteTable
 */
resource "aws_route_table" "public-route" {
    vpc_id = "${aws_vpc.main-vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.public-igw.id}"
    }
    tags = {
        Name = "${var.app_name}-public-route"
    }
}
resource "aws_route_table_association" "puclic-1" {
    subnet_id      = "${aws_subnet.main-publicsubnet-1.id}"
    route_table_id = "${aws_route_table.public-route.id}"
}
resource "aws_route_table_association" "puclic-2" {
    subnet_id      = "${aws_subnet.main-publicsubnet-2.id}"
    route_table_id = "${aws_route_table.public-route.id}"
}

resource "aws_route_table" "private-route" {
    vpc_id = "${aws_vpc.main-vpc.id}"
    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.main-ngw.id}"
    }
    tags = {
        Name = "${var.app_name}-private-route"
    }
}
resource "aws_route_table_association" "private-1" {
    subnet_id      = "${aws_subnet.main-privatesubnet-1.id}"
    route_table_id = "${aws_route_table.private-route.id}"
}
resource "aws_route_table_association" "private-2" {
    subnet_id      = "${aws_subnet.main-privatesubnet-2.id}"
    route_table_id = "${aws_route_table.private-route.id}"
}
