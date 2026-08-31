# Dublin - eu-west-1
resource "aws_vpc" "vpc_dub" {
  for_each = {
    for k, v in local.vpc[var.environment] : k => v
    if v.0 == "eu-west-1"
  }
  provider             = aws.dublin
  cidr_block           = each.value[1]
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(local.global_tags, {
    Name = each.key
  })
}

# Virginia - us-east-1
resource "aws_vpc" "vpc_vir" {
  for_each = {
    for k, v in local.vpc[var.environment] : k => v
    if v.0 == "us-east-1"
  }
  provider             = aws.virginia
  cidr_block           = each.value[1]
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(local.global_tags, {
    Name = each.key
  })
}

# Mumbai - ap-south-1
resource "aws_vpc" "vpc_mum" {
  for_each = {
    for k, v in local.vpc[var.environment] : k => v
    if v.0 == "ap-south-1"
  }
  provider             = aws.mumbai
  cidr_block           = each.value[1]
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(local.global_tags, {
    Name = each.key
  })
}