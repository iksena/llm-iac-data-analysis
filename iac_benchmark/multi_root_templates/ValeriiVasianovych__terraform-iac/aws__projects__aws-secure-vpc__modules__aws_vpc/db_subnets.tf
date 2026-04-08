resource "aws_subnet" "db_private_subnets" {
  count             = length(var.db_private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.db_private_subnet_cidrs, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.env}-db-private-subnet-${count.index + 1}"
    CIDR = element(var.db_private_subnet_cidrs, count.index)
  }
}

# not be able to access the internet from and to
resource "aws_route_table" "db_private_subnets" {
  count  = length(var.db_private_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.env}-db-route-private-subnets-${count.index + 1}"
  }
}

resource "aws_route_table_association" "db_private_routes" {
  count          = length(aws_subnet.db_private_subnets[*].id)
  route_table_id = aws_route_table.db_private_subnets[count.index].id
  subnet_id      = element(aws_subnet.db_private_subnets[*].id, count.index)
}




