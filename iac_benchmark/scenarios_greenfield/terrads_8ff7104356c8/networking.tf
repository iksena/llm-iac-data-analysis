resource "aws_vpc" "K8s" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "name" = "K8s"
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.K8s.id

  tags = {
    Name = "IGW"
  }
}

# Create two public and two private subnets in different AZs
resource "aws_subnet" "my_subnet" {
  count = 2

  vpc_id                  = aws_vpc.K8s.id
  cidr_block              = "192.168.${1 + count.index}.0/24"
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
}

resource "aws_route_table" "Public_RT" {
  vpc_id = aws_vpc.K8s.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "Public_RT"
  }
}

resource "aws_route_table_association" "k8s" {
  count          = 2
  route_table_id = aws_route_table.Public_RT.id
  subnet_id      = count.index % 2 == 0 ? aws_subnet.my_subnet[0].id : aws_subnet.my_subnet[1].id
}
