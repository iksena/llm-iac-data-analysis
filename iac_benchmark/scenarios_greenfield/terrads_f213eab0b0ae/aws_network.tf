# Module for managing Virtual Private Cloud  on AWS

resource "aws_vpc" "financy_vpc" {
    cidr_block = var.vpc_cidr_block
    instance_tenancy = var.vpc_instance_tenancy
    enable_dns_hostnames = var.vpc_enable_dns_hostnames
    enable_dns_support = var.vpc_enable_dns_support
    tags = {
      "Name" = "${var.vpc_name}-vpc"
      "Environment" = var.environment
    }
}
resource "aws_internet_gateway" "financy_gateway" {
  depends_on = [aws_vpc.financy_vpc]
  vpc_id = aws_vpc.financy_vpc.id
  tags = {
      "Name" = "${var.internet_gateway_name}-gateway"
      "Environment" = var.environment
    }
}
resource "aws_subnet" "financy_main_subnet" {
  depends_on = [
    aws_vpc.financy_vpc,
    aws_internet_gateway.financy_gateway
  ]
  vpc_id = aws_vpc.financy_vpc.id
  count  = "${length(var.subnets_cidr_list)}"
  cidr_block = "${element(var.subnets_cidr_list, count.index)}"
  availability_zone = "${element(var.availability_zones_list,   count.index)}"
  map_public_ip_on_launch = true


    tags = {
      "Name" = "${var.environment}-${element(var.availability_zones_list, count.index)}-financy-subnet"
      "Environment" = var.environment
    }
}
resource "aws_route_table" "financy_public_route_table" {
  vpc_id = aws_vpc.financy_vpc.id
tags = {
      "Name" = "${var.environment}-PUBLIC-route-table"
      "Environment" = var.environment
    }
}
resource "aws_route" "internet_gw_route" {
  route_table_id            = aws_route_table.financy_public_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.financy_gateway.id
  depends_on                = [aws_route_table.financy_public_route_table]
}
resource "aws_route_table_association" "public_association" {
  count          = "${length(var.subnets_cidr_list)}"
  subnet_id      = "${element(aws_subnet.financy_main_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.financy_public_route_table.id}"
}
resource "aws_main_route_table_association" "main_route_table" {
  vpc_id         = aws_vpc.financy_vpc.id
  route_table_id = aws_route_table.financy_public_route_table.id
}
resource "aws_security_group" "public_security_group" {
  name        = "${var.environment}-${var.project_name}-public-sec-group"
  description = "Public access to VPC"
  vpc_id = aws_vpc.financy_vpc.id

  dynamic "ingress" {
    for_each = lookup(var.public_allowed_port_list_map, var.environment)
    content {
      description = "Public access"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Public access points"
  }
}
resource "aws_security_group" "admin_security_group" {
  name        = "${var.environment}-${var.project_name}-admin-sec-group"
  description = "Admin access to VPC"
  vpc_id = aws_vpc.financy_vpc.id

  dynamic "ingress" {
    for_each = lookup(var.admin_allowed_port_list_map, var.environment)
    content {
      description = "Admin access"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.admin_ip_cidr]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Admin access points"
  }
}
