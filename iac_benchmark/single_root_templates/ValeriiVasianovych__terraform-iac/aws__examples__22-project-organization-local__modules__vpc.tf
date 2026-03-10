# ── variables.tf ────────────────────────────────────
variable "region" {
  default = "us-east-1"
}

variable "env" {
  default = "test"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = [
    "10.0.10.0/24",
    "10.0.11.0/24"
  ]
}

variable "private_subnet_cidrs" {
  default = [
    "10.0.20.0/24",
    "10.0.21.0/24"
  ]
}

variable "common_tags" {
  default = {
    Owner: "Valerii Vasianovych"
    Project: "Terraform AWS"
  }
}

# ── outputs.tf ────────────────────────────────────
output "region" {
  value = data.aws_region.current.description
}

output "account_id" {
  value = data.aws_caller_identity.current.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

output "vpc_cidr" {
  value = var.vpc_cidr
}

output "public_subnet_cidrs" {
  value = var.public_subnet_cidrs
}

output "private_subnet_cidrs" {
  value = var.private_subnet_cidrs
}

# ── datasource.tf ────────────────────────────────────
# Global 
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}


# ── subnets.tf ────────────────────────────────────
# Public subnets
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, {
    Name   = "${var.env}-public-subnet-${count.index + 1}"
    Region = "Region: ${var.region}"
  })
}

resource "aws_route_table" "public_subnets" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.common_tags, {
    Name   = "${var.env}-route-public-subnets"
    Region = "Region: ${var.region}"
  })
}

resource "aws_route_table_association" "public_routes" {
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.public_subnets.id
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
}

# Private subnets
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(var.common_tags, {
    Name   = "${var.env}-private-subnet-${count.index + 1}"
    Region = "Region: ${var.region}"
  })
}

resource "aws_eip" "nat" {
  count = length(var.private_subnet_cidrs)

  tags = merge(var.common_tags, {
    Name   = "${var.env}-nat-eip-${count.index + 1}"
    Region = "Region: ${var.region}"
  })
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.private_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = element(aws_subnet.public_subnets[*].id, count.index)

  tags = merge(var.common_tags, {
    Name   = "${var.env}-nat-gw-${count.index + 1}"
    Region = "Region: ${var.region}"
  })
}

resource "aws_route_table" "private_subnets" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat[count.index].id
  }

  tags = merge(var.common_tags, {
    Name   = "${var.env}-route-private-subnets-${count.index + 1}"
    Region = "Region: ${var.region}"
  })
}

resource "aws_route_table_association" "private_routes" {
  count          = length(aws_subnet.private_subnets[*].id)
  route_table_id = aws_route_table.private_subnets[count.index].id
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
}


# ── vpc.tf ────────────────────────────────────
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = merge(var.common_tags, {
    Name   = "${var.env}-vpc"
    Region = "Region: ${var.region}"
  })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = merge(var.common_tags, {
    Name   = "${var.env}-igw"
    Region = "Region: ${var.region}"
  })
}