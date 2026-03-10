# ── variables.tf ────────────────────────────────────
# Infrastructure Configuration
variable "region" {
  description = "The AWS region"
  type        = string
  default     = ""
}

variable "env" {
  description = "The environment"
  type        = string
  default     = ""
}

variable "account_id" {
  description = "The AWS account ID"
  type        = string
  default     = ""
}

# Network Configuration
variable "vpc_id" {
  description = "The VPC ID"
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "The CIRDR block for the VPC"
  type        = string
  default     = ""
}

variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
  default     = []
}

variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
  default     = []
}

variable "db_private_subnet_cidrs" {
  description = "The CIDR blocks for the database subnets"
  type        = list(string)
  default     = []
}

# ── outputs.tf ────────────────────────────────────
output "region" {
  value = var.region
}

output "env" {
  value = var.env
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr_block" {
  value = aws_vpc.main.cidr_block
}

output "public_subnet_cidr_blocks" {
  value = length(aws_subnet.public_subnets) > 0 ? aws_subnet.public_subnets[*].cidr_block : []
}

output "public_subnet_ids" {
  value = length(aws_subnet.public_subnets) > 0 ? aws_subnet.public_subnets[*].id : []
}

output "private_subnet_cidr_blocks" {
  value = length(aws_subnet.private_subnets) > 0 ? aws_subnet.private_subnets[*].cidr_block : []
}

output "private_subnet_ids" {
  value = length(aws_subnet.private_subnets) > 0 ? aws_subnet.private_subnets[*].id : []
}

output "db_private_subnet_cidr_blocks" {
  value = length(aws_subnet.db_private_subnets) > 0 ? aws_subnet.db_private_subnets[*].cidr_block : []

}

output "db_private_subnet_ids" {
  value = length(aws_subnet.db_private_subnets) > 0 ? aws_subnet.db_private_subnets[*].id : []
}

# ── db_subnets.tf ────────────────────────────────────
resource "aws_subnet" "db_private_subnets" {
  count             = length(var.db_private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.db_private_subnet_cidrs, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.env}-db-private-subnet-${count.index + 1}"
    CIDR = element(var.db_private_subnet_cidrs, count.index)
  }
}

# not be able to access the internet from and to
resource "aws_route_table" "db_private_subnets" {
  count  = length(var.db_private_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.env}-db-route-private-subnets-${count.index + 1}"
  }
}

resource "aws_route_table_association" "db_private_routes" {
  count          = length(aws_subnet.db_private_subnets[*].id)
  route_table_id = aws_route_table.db_private_subnets[count.index].id
  subnet_id      = element(aws_subnet.db_private_subnets[*].id, count.index)
}






# ── private-subnets.tf ────────────────────────────────────
resource "aws_eip" "nat" {
  count = length(var.private_subnet_cidrs)
  tags = {
    Name = "${var.env}-eip-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.private_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id
  tags = {
    Name = "${var.env}-nat-gw-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.env}-private-subnet-${count.index + 1}"
    CIDR = var.private_subnet_cidrs[count.index]
  }
}

resource "aws_route_table" "private_subnets" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }
  tags = {
    Name = "${var.env}-route-private-subnets-${count.index + 1}"
  }
}

resource "aws_route_table_association" "private_routes" {
  count          = length(var.private_subnet_cidrs)
  route_table_id = aws_route_table.private_subnets[count.index].id
  subnet_id      = aws_subnet.private_subnets[count.index].id
}

# ── public-subnets.tf ────────────────────────────────────
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-public-subnet-${count.index + 1}"
    CIDR = element(var.public_subnet_cidrs, count.index)
  }
}

resource "aws_route_table" "public_subnets" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${var.env}-route-public-subnets"
  }
}

resource "aws_route_table_association" "public_routes" {
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.public_subnets.id
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
}

# ── vpc.tf ────────────────────────────────────
data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "vpc-${var.env}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "igw-${var.env}"
  }
}