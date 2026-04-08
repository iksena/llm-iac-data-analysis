resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Owner: "TimS"
    Name: "tims-kunlaquota-vps"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Owner: "TimS"
    Name: "tims-kunlaquota-subnet-a"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-central-1b"

  tags = {
    Owner: "TimS"
    Name: "tims-kunlaquota-subnet-b"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Owner: "TimS"
    Name: "tims-kunlaquota-internet-gateway"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Owner: "TimS"
    Name: "tims-kunlaquota-route-table"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id

#   tags = {
#     Owner: "TimS"
#     Name: "tims-kunlaquota-default-route"
#   }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.rt.id

#   tags = {
#     Owner: "TimS"
#     Name: "tims-kunlaquota-route-assoc-a"
#   }
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.rt.id

#   tags = {
#     Owner: "TimS"
#     Name: "tims-kunlaquota-route-assoc-b"
#   }
}


resource "aws_vpc_endpoint" "ssm" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.eu-central-1.ssm"
  subnet_ids   = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  vpc_endpoint_type = "Interface"

  private_dns_enabled = true

  tags = {
    Name = "ssm-endpoint"
  }
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.eu-central-1.ssmmessages"
  subnet_ids   = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  vpc_endpoint_type = "Interface"

  private_dns_enabled = true

  tags = {
    Name = "ssm-messages-endpoint"
  }
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.eu-central-1.ec2messages"
  subnet_ids   = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  vpc_endpoint_type = "Interface"

  private_dns_enabled = true

  tags = {
    Name = "ec2-messages-endpoint"
  }
}
