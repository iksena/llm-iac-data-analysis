# Create Private route table
resource "aws_route_table" "webhost_private_rt" {
  vpc_id = aws_vpc.webhost_vpc.id

  tags = {
    "Name" = "${var.AWS_ENV}_private_rt",
    "Env" = var.AWS_ENV
  }
}

# Associate private subnet to Private RT
resource "aws_route_table_association" "webhost_private_rt_associate" {
    subnet_id = aws_subnet.webhost_private_subnet.id
    route_table_id = aws_route_table.webhost_private_rt.id
}

# Acquire EIP
resource "aws_eip" "webhost_natgw_eip" {
  vpc = true
    tags = {
    "Name" = "${var.AWS_ENV}_natgw_eip"
    "Env" = var.AWS_ENV
  }
}  
  
# Create NAT Gateway
resource "aws_nat_gateway" "webhost_nat_gateway" {
  allocation_id = aws_eip.webhost_natgw_eip.id
  subnet_id     = aws_subnet.webhost_public_subnet.id

  tags = {
    "Name" = "${var.AWS_ENV}_natgw"
    "Env" = var.AWS_ENV
  }
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.webhost_igw]
}


#  Route to NAT Gateway
resource "aws_route" "webhost_private_rt" {
    route_table_id = aws_route_table.webhost_private_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.webhost_nat_gateway.id
}