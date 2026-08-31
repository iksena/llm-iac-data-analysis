#  Create Internet Gateway
resource "aws_internet_gateway" "webhost_igw" {
    vpc_id = aws_vpc.webhost_vpc.id
    tags = {
      "Name" = "${var.AWS_ENV}_igw",
      "Env" = var.AWS_ENV
    }

}

# Create Public route table
resource "aws_route_table" "webhost_public_rt" {
  vpc_id = aws_vpc.webhost_vpc.id

  tags = {
    "Name" = "${var.AWS_ENV}_public_rt",
    "Env" = var.AWS_ENV
  }
}

# Associate public subnet to Public RT
resource "aws_route_table_association" "webhost_public_rt_associate" {
    subnet_id = aws_subnet.webhost_public_subnet.id
    route_table_id = aws_route_table.webhost_public_rt.id
}

#  Route to Internet Gateway
resource "aws_route" "webhost_public_rt" {
    route_table_id = aws_route_table.webhost_public_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.webhost_igw.id
}