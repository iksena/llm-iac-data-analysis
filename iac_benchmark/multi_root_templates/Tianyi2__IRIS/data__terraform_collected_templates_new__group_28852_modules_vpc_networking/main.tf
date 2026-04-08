resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = merge({ Name = var.vpc_name }, var.vpc_tags)
}

# Private
resource "aws_subnet" "private" {
  for_each = var.private_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]
  tags = merge({ Name = each.key }, var.private_subnet_tags)
  map_public_ip_on_launch = false
}

# Public
resource "aws_subnet" "public" {
  for_each          = var.public_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]
  tags = merge({ Name = each.key }, var.public_subnet_tags)
  map_public_ip_on_launch = true
}


# Required so that the nodes can access the internet
resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    ## XXX redundant? AWS seems to create this route by default
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public.id
  }

  tags = {
    Name = "${var.vpc_name} Public Subnet Route Table"
  }
}

resource "aws_route_table_association" "public" {
  for_each       = var.public_subnets
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

# NAT gateways require EIPs
resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Name = "${var.vpc_name} Private NAT GW"
  }
}

# NAT gateway so that private instances can access the internet
# pub_keys = keys(var.pubic_subnets)
# first_pub_subnet = slice(pub_keys, 0, 1)
resource "aws_nat_gateway" "main" {
  subnet_id     = aws_subnet.public[slice(keys(var.public_subnets), 0, 1)[0]].id
  allocation_id = aws_eip.nat.id
  tags = {
    Name = "${var.vpc_name} Private Subnet NAT GW"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }


  tags = {
    Name = "${var.vpc_name} Private Subnet route table"
  }
}

resource "aws_route_table_association" "private" {
  for_each       = var.private_subnets
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private.id
}


resource "aws_security_group" "public" {
  name        = "public"
  description = "Allow incoming traffic from Internet"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Allow everything to talk to everything inside of public"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}  Public subnet access"
  }
}

resource "aws_security_group" "private" {
  name        = "private"
  description = "Allow traffic to/from private subnet"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow everything to talk to everything inside of private"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name} Private Subnet Access"
  }

}

resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id = aws_vpc.main.id
}
