provider "aws" {
  region = module.common_vars.region
}

resource "aws_vpc" "main" {
  cidr_block = module.common_vars.cidr_block
    tags = merge(module.common_vars.common_tags, {
     Name        = "VPC-${module.common_vars.env}"
     Environment = module.common_vars.env
  })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(module.common_vars.common_tags, {
     Name        = "IGW-${module.common_vars.env}"
     Environment = module.common_vars.env
  })
}

resource "aws_subnet" "public_subnet" {
  count      = length(module.common_vars.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(module.common_vars.public_subnet_cidrs, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
    tags = merge(module.common_vars.common_tags, {
     Name        = "Public-Subnet-${module.common_vars.env}-${data.aws_availability_zones.available.names[count.index]}-${count.index + 1}"
     Environment = module.common_vars.env
  })
}

resource "aws_route_table" "public_subnets" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }
    tags = merge(module.common_vars.common_tags, {
     Name        = "Route-Table-${module.common_vars.env}"
     Environment = "${module.common_vars.env}"
  })
}

resource "aws_route_table_association" "public_subnets" {
  count = length(aws_subnet.public_subnet[*].id)
  route_table_id = aws_route_table.public_subnets.id
  subnet_id = element(aws_subnet.public_subnet[*].id, count.index)
}