# Dublin - eu-west-1
resource "aws_subnet" "public_subnet_dub" {
  for_each = {
    for idx, subnet in local.subnet_map : idx => subnet
    if subnet.region == "eu-west-1"
  }
  provider          = aws.dublin
  vpc_id            = aws_vpc.vpc_dub[each.value.vpc_key].id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az
}
resource "aws_route_table" "public_dub" {
  for_each = {
    for idx, rt in local.subnet_map : idx => rt
    if rt.region == "eu-west-1"
  }
  provider = aws.dublin
  vpc_id   = aws_vpc.vpc_dub[each.value.vpc_key].id
}
resource "aws_route_table_association" "public_dub" {
  for_each = {
    for idx, rt in local.subnet_map : idx => rt
    if rt.region == "eu-west-1"
  }
  provider       = aws.dublin
  subnet_id      = aws_subnet.public_subnet_dub[each.key].id
  route_table_id = aws_route_table.public_dub[each.key].id
}

# Virginia - us-east-1
resource "aws_subnet" "public_subnet_vir" {
  for_each = {
    for idx, subnet in local.subnet_map : idx => subnet
    if subnet.region == "us-east-1"
  }
  provider          = aws.virginia
  vpc_id            = aws_vpc.vpc_vir[each.value.vpc_key].id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az
}
resource "aws_route_table" "public_vir" {
  for_each = {
    for idx, rt in local.subnet_map : idx => rt
    if rt.region == "us-east-1"
  }
  provider = aws.virginia
  vpc_id   = aws_vpc.vpc_vir[each.value.vpc_key].id
}
resource "aws_route_table_association" "public_vir" {
  for_each = {
    for idx, rt in local.subnet_map : idx => rt
    if rt.region == "us-east-1"
  }
  provider       = aws.virginia
  subnet_id      = aws_subnet.public_subnet_vir[each.key].id
  route_table_id = aws_route_table.public_vir[each.key].id
}

# Mumbai - ap-south-1
resource "aws_subnet" "public_subnet_mum" {
  for_each = {
    for idx, subnet in local.subnet_map : idx => subnet
    if subnet.region == "ap-south-1"
  }
  provider          = aws.mumbai
  vpc_id            = aws_vpc.vpc_mum[each.value.vpc_key].id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az
}
resource "aws_route_table" "public_mum" {
  for_each = {
    for idx, rt in local.subnet_map : idx => rt
    if rt.region == "ap-south-1"
  }
  provider = aws.mumbai
  vpc_id   = aws_vpc.vpc_mum[each.value.vpc_key].id
}
resource "aws_route_table_association" "public_mum" {
  for_each = {
    for idx, rt in local.subnet_map : idx => rt
    if rt.region == "ap-south-1"
  }
  provider       = aws.mumbai
  subnet_id      = aws_subnet.public_subnet_mum[each.key].id
  route_table_id = aws_route_table.public_mum[each.key].id
}