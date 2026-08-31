#Route Table (Public)
resource "aws_route_table" "weasel_crm_rt_pub" {
  vpc_id = aws_vpc.weasel_crm_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.weasel_crm_gw.id
  }
}

resource "aws_route_table_association" "rt_pub_a" {
  subnet_id      = aws_subnet.weasel_crm_public1.id
  route_table_id = aws_route_table.weasel_crm_rt_pub.id
}

resource "aws_route_table_association" "weasel_crm_rt_pub_b" {
  subnet_id      = aws_subnet.weasel_crm_public2.id
  route_table_id = aws_route_table.weasel_crm_rt_pub.id
}

resource "aws_route_table_association" "weasel_crm_rt_pub_c" {
  subnet_id      = aws_subnet.weasel_crm_public3.id
  route_table_id = aws_route_table.weasel_crm_rt_pub.id
}

#Route table (Private)
resource "aws_route_table" "weasel_crm_rt_prv" {
  vpc_id = aws_vpc.weasel_crm_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.weasel_crm_ngw.id
  }
}

resource "aws_route_table_association" "rt_prv_a" {
  subnet_id      = aws_subnet.weasel_crm_private1.id
  route_table_id = aws_route_table.weasel_crm_rt_prv.id
}

resource "aws_route_table_association" "rt_prv_b" {
  subnet_id      = aws_subnet.weasel_crm_private2.id
  route_table_id = aws_route_table.weasel_crm_rt_prv.id
}

resource "aws_route_table_association" "rt_prv_c" {
  subnet_id      = aws_subnet.weasel_crm_private3.id
  route_table_id = aws_route_table.weasel_crm_rt_prv.id
}