resource "aws_internet_gateway" "vpc_internet_gateway" {
    vpc_id = aws_vpc.vpc.id
}

resource "aws_eip" "nat_eip" {
  vpc      = true
  depends_on = [aws_internet_gateway.vpc_internet_gateway]
}

resource "aws_nat_gateway" "app_nat_gateway" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public_subnet.id
    depends_on = [
      aws_eip.nat_eip,
      aws_subnet.public_subnet]
}

