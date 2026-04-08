resource "aws_eip" "nat" {
  count = length(var.private_subnet_cidrs) # Number of EIPs for NAT gateways based on the number of private subnets
  tags = merge(var.common_tags, {
    Name   = "${var.env}-nat-eip-${count.index + 1}"
    Region = "Region: ${var.region}"
  })
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.private_subnet_cidrs) # Number of NAT gateways based on the number of private subnets
  allocation_id = aws_eip.nat[count.index].id # Each NAT gateway is associated with a separate EIP
  subnet_id     = element(aws_subnet.public_subnets[*].id, count.index) # value of the public subnet ID, used to associate the NAT gateway with each private subnet
  tags = merge(var.common_tags, {
    Name   = "${var.env}-nat-gw-${count.index + 1}"
    Region = "Region: ${var.region}"
  })
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs) # Number of private subnets based on the number of CIDRs provided
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidrs, count.index) # Number of CIDRs provided for private subnets based on the count.index
  availability_zone = data.aws_availability_zones.available.names[count.index] # Availability zone based on the count.index
  tags = merge(var.common_tags, {
    Name   = "${var.env}-private-subnet-${count.index + 1}"
    Region = "Region: ${var.region}"
  })
}

resource "aws_route_table" "private_subnets" {
  count  = length(var.private_subnet_cidrs) # Number of route tables based on the number of private subnets
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    # gateway_id = aws_nat_gateway.nat[count.index].id
  }
  tags = merge(var.common_tags, {
    Name   = "${var.env}-route-private-subnets-${count.index + 1}"
    Region = "Region: ${var.region}"
  })
}

resource "aws_route_table_association" "private_routes" {
  count          = length(aws_subnet.private_subnets[*].id) # Number of route table associations based on the number of private subnets
  route_table_id = aws_route_table.private_subnets[count.index].id # Route table ID based on the count.index
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index) # Subnet ID based on the count.index
}