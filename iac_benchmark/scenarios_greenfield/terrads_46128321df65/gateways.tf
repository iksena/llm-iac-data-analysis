# Dublin - eu-west-1
resource "aws_internet_gateway" "igw_dub" {
  for_each = {
    for k, v in local.vpc[var.environment] : k => v
    if v.0 == "eu-west-1"
  }
  provider = aws.dublin
  vpc_id   = aws_vpc.vpc_dub[each.key].id
}

# Virginia - us-east-1
resource "aws_internet_gateway" "igw_vir" {
  for_each = {
    for k, v in local.vpc[var.environment] : k => v
    if v.0 == "us-east-1"
  }
  provider = aws.virginia
  vpc_id   = aws_vpc.vpc_vir[each.key].id
}

# Mumbai - ap-south-1
resource "aws_internet_gateway" "igw_mum" {
  for_each = {
    for k, v in local.vpc[var.environment] : k => v
    if v.0 == "ap-south-1"
  }
  provider = aws.mumbai
  vpc_id   = aws_vpc.vpc_mum[each.key].id
}