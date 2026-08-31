resource "aws_vpc" "vpc_main" {
  cidr_block                           = "192.168.0.0/16"
  assign_generated_ipv6_cidr_block     = true
  enable_dns_hostnames                 = true
  enable_network_address_usage_metrics = true
  tags = {
    Name = "Main Public VPC"
  }
}

resource "aws_subnet" "subnet_main" {
  vpc_id                                         = aws_vpc.vpc_main.id
  cidr_block                                     = "192.168.22.0/24"
  ipv6_cidr_block                                = cidrsubnet(aws_vpc.vpc_main.ipv6_cidr_block, 8, 0)
  availability_zone                              = var.availability_zone_name
  enable_resource_name_dns_a_record_on_launch    = true
  enable_resource_name_dns_aaaa_record_on_launch = true
  assign_ipv6_address_on_creation                = true
  map_public_ip_on_launch                        = true
  tags = {
    Name = "Main Public Subnet"
  }
}

resource "aws_subnet" "subnet_twentythree" {
  vpc_id                                         = aws_vpc.vpc_main.id
  cidr_block                                     = "192.168.23.0/24"
  ipv6_cidr_block                                = cidrsubnet(aws_vpc.vpc_main.ipv6_cidr_block, 8, 1)
  availability_zone                              = var.availability_zone_name
  enable_resource_name_dns_a_record_on_launch    = true
  enable_resource_name_dns_aaaa_record_on_launch = true
  assign_ipv6_address_on_creation                = true
  map_public_ip_on_launch                        = true
  tags = {
    Name = "Additional Public Subnet"
  }
}

resource "aws_internet_gateway" "ig_main" {
  vpc_id = aws_vpc.vpc_main.id
  tags = {
    Name = "Main Public Internet Gateway"
  }
}

resource "aws_route" "defaultIPv4route" {
  route_table_id         = aws_vpc.vpc_main.default_route_table_id
  gateway_id             = aws_internet_gateway.ig_main.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "defaultIPv6route" {
  route_table_id              = aws_vpc.vpc_main.default_route_table_id
  gateway_id                  = aws_internet_gateway.ig_main.id
  destination_ipv6_cidr_block = "::/0"
}
