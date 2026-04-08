resource "aws_vpc_peering_connection" "vpc_peering" {
  provider = aws.vpc-1
  vpc_id = aws_vpc.vpc-1.id
  peer_vpc_id = aws_vpc.vpc-2.id
  peer_region = var.vpc_region_2
  tags = merge(var.common_tags, {
    Name = "vpc-peering"
  })
  depends_on = [ aws_vpc.vpc-1, aws_vpc.vpc-2 ]
}

resource "aws_vpc_peering_connection_accepter" "vpc_peering_accepter" {
  provider = aws.vpc-2
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
  auto_accept = true

  depends_on = [ aws_vpc_peering_connection.vpc_peering ]
}