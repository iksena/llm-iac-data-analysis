resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = merge(var.tags, { Name = "openldap-vpc" })
}

resource "aws_subnet" "default_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = var.availability_zone

  tags = merge(var.tags, { Name = "openldap-subnet" })
}
