# Self-contained VPC + public/private subnets, used only when vpc_id/public_subnets/
# private_subnets are left at their default (blank/empty) values.
resource "aws_vpc" "benchmark" {
  count                = var.vpc_id == "" ? 1 : 0
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.name}-vpc"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public" {
  count                   = var.vpc_id == "" ? 2 : 0
  vpc_id                  = aws_vpc.benchmark[0].id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.name}-public-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count             = var.vpc_id == "" ? 2 : 0
  vpc_id            = aws_vpc.benchmark[0].id
  cidr_block        = "10.0.${count.index + 11}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.name}-private-${count.index}"
  }
}

resource "aws_internet_gateway" "benchmark" {
  count  = var.vpc_id == "" ? 1 : 0
  vpc_id = aws_vpc.benchmark[0].id
}

resource "aws_route_table" "public" {
  count  = var.vpc_id == "" ? 1 : 0
  vpc_id = aws_vpc.benchmark[0].id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.benchmark[0].id
  }
}

resource "aws_route_table_association" "public" {
  count          = var.vpc_id == "" ? 2 : 0
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}

locals {
  effective_vpc_id         = var.vpc_id != "" ? var.vpc_id : aws_vpc.benchmark[0].id
  effective_public_subnets = length(var.public_subnets) > 0 ? var.public_subnets : aws_subnet.public[*].id
  effective_private_subnets = length(var.private_subnets) > 0 ? var.private_subnets : aws_subnet.private[*].id
}

resource "aws_key_pair" "eks_terraform_key" {
  key_name   = "eks-terraform-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDOJLyjuojlYkqhtIGi+xOltH5OCtigG5wmvDFpTztarHngLk/MtS0tUD11jUdnBfiMoAz47KNdYrUFbcTeN76amTxHeIW7ASZWcZguxo2f+g3v7FZj/aLTraFs8ZF8GAXoZSAszEpkRS2RPkMY9mFttbCQ8AE9JpGTDrY6KFqsBVu0xJ+Glk216RtcWymlvIqak/gQCl7ijfWgwpPCnmjWFaWb8jeF19hf33PKUJ6RCCQQGpHc2eyegRXP+0Ce9f1WmxUEun75hzGPNgtlrFYNIFhNhxJ31gtXDy/svf/fbbzgjnU8mD5XVYko50nz8w/cTtBMNtLi6SOP76gJPolj benchmark"
}
