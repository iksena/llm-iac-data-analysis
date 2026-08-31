# VPC
resource "aws_vpc" "weasel_crm_vpc" {
  cidr_block = var.cidr_block
  tags       = var.tags
}

#Private Subnets
resource "aws_subnet" "weasel_crm_private1" {
  vpc_id            = aws_vpc.weasel_crm_vpc.id
  cidr_block        = var.private_cidr1
  availability_zone = "${var.region}a"
  tags              = var.tags
}

resource "aws_subnet" "weasel_crm_private2" {
  vpc_id            = aws_vpc.weasel_crm_vpc.id
  cidr_block        = var.private_cidr2
  availability_zone = "${var.region}b"
  tags              = var.tags
}

resource "aws_subnet" "weasel_crm_private3" {
  vpc_id            = aws_vpc.weasel_crm_vpc.id
  cidr_block        = var.private_cidr3
  availability_zone = "${var.region}c"
  tags              = var.tags
}

#Public Subnets
resource "aws_subnet" "weasel_crm_public1" {
  vpc_id                  = aws_vpc.weasel_crm_vpc.id
  cidr_block              = var.public_cidr1
  availability_zone       = "${var.region}a"
  tags                    = var.tags
  map_public_ip_on_launch = true
}

resource "aws_subnet" "weasel_crm_public2" {
  vpc_id                  = aws_vpc.weasel_crm_vpc.id
  cidr_block              = var.public_cidr2
  availability_zone       = "${var.region}b"
  tags                    = var.tags
  map_public_ip_on_launch = true
}

resource "aws_subnet" "weasel_crm_public3" {
  vpc_id                  = aws_vpc.weasel_crm_vpc.id
  cidr_block              = var.public_cidr3
  availability_zone       = "${var.region}c"
  tags                    = var.tags
  map_public_ip_on_launch = true
}

#DB subnet group
resource "aws_db_subnet_group" "weasel_crm_db_subnet_group" {
  name       = "weasel-crm-db-subnet-group"
  subnet_ids = [aws_subnet.weasel_crm_private1.id, aws_subnet.weasel_crm_private2.id, aws_subnet.weasel_crm_private3.id]

  tags = {
    Name = "My DB Subnet Group"
  }
}