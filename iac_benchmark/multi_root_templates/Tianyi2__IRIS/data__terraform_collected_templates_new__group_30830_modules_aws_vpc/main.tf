# Internet VPC
resource "aws_vpc" "vpc" {
    cidr_block = "${var.cidr}"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    tags = {
        Name = "${var.vpc_name}"
    }
}

# Subnets - public
resource "aws_subnet" "public" {
    count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0
    
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.public_subnets[count.index]}"
    map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
    availability_zone = "${var.azs[count.index]}"

    tags = {
        Name = "${var.vpc_name}-${var.public_subnet_suffix}-${count.index}"
    }
}

# Subnets - private
resource "aws_subnet" "private" {
    count = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.private_subnets[count.index]}"
    availability_zone = "${var.azs[count.index]}"

    tags = {
        Name = "${var.vpc_name}-${var.private_subnet_suffix}-${count.index}"
    }
}


# Internet GW
resource "aws_internet_gateway" "i-gw" {
    vpc_id = "${aws_vpc.vpc.id}"
    tags = {
        Name = "${var.vpc_name}"
    }
}

# Routes tables
resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.i-gw.id}"
    }

    tags = {
        Name = "${var.vpc_name}-${var.public_subnet_suffix}"
    }
}

# Route association public
resource "aws_route_table_association" "public" {
    count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

    subnet_id = element(aws_subnet.public[*].id, count.index)
    route_table_id = "${aws_route_table.public.id}"
}
