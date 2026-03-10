# ── variables.tf ────────────────────────────────────
# VPC-1
variable "vpc_region_1" {
  description = "The region of the VPC"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr_1" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_1" {
  description = "The CIDR block for the subnet"
  type        = string
  default     = "10.0.10.0/24"
}

# VPC-2
variable "vpc_region_2" {
  description = "The region of the VPC"
  type        = string
  default     = "us-east-2"
}

variable "vpc_cidr_2" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "172.0.0.0/16"
}

variable "subnet_cidr_2" {
  description = "The CIDR block for the subnet"
  type        = string
  default     = "172.0.10.0/24"
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {
    Owner = "DevOps Team"
    Project = "AWS VPC Peering Connection"
  }
}

locals {
  vpc_1_name = "vpc-1"
  vpc_2_name = "vpc-2"
}

# ── outputs.tf ────────────────────────────────────
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "vpc_peering_id" {
  value = aws_vpc_peering_connection.vpc_peering.id
}

# VPC-1
output "vpc_1_cidr" {
  value = aws_vpc.vpc-1.cidr_block
}

output "vpc_1_id" {
  value = aws_vpc.vpc-1.id
}

output "subnet_1_cidr" {
  value = aws_subnet.subnet-1.cidr_block
}

# VPC-2
output "vpc_2_cidr" {
  value = aws_vpc.vpc-2.cidr_block
}

output "vpc_2_id" {
  value = aws_vpc.vpc-2.id
}

output "subnet_2_cidr" {
  value = aws_subnet.subnet-2.cidr_block
}

# ── datasource.tf ────────────────────────────────────
data "aws_caller_identity" "current" {}

# ── peering-connection.tf ────────────────────────────────────
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

# ── vpc-1.tf ────────────────────────────────────
provider "aws" {
  region = var.vpc_region_1
  alias  = "vpc-1"
}

resource "aws_vpc" "vpc-1" {
  cidr_block = var.vpc_cidr_1
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = merge(var.common_tags, {
    Name = "vpc-1"
  })
}

resource "aws_internet_gateway" "igw-1" {
  vpc_id = aws_vpc.vpc-1.id
  tags = merge(var.common_tags, {
    Name = "igw-${local.vpc_1_name}"
  })
}

resource "aws_subnet" "subnet-1" {
  provider   = aws.vpc-1
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = var.subnet_cidr_1
  map_public_ip_on_launch = true
  tags = merge(var.common_tags, {
    Name = "subnet-${local.vpc_1_name}"
  })
}

resource "aws_route_table" "vpc_1_igw" {
  provider = aws.vpc-1
  vpc_id = aws_vpc.vpc-1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-1.id
  }
    tags = merge(var.common_tags, {
        Name = "route-table-${local.vpc_1_name}"
    })
}

resource "aws_route" "vpc_1_to_vpc_2" {
  provider = aws.vpc-1
  route_table_id = aws_route_table.vpc_1_igw.id
  destination_cidr_block = var.vpc_cidr_2
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

resource "aws_route_table_association" "subnet_1_association" {
  provider = aws.vpc-1
  subnet_id = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.vpc_1_igw.id
}

# ── vpc-2.tf ────────────────────────────────────
provider "aws" {
  region = var.vpc_region_2
  alias  = "vpc-2"
}

resource "aws_vpc" "vpc-2" {
  provider = aws.vpc-2
  cidr_block = var.vpc_cidr_2
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = merge(var.common_tags, {
    Name = "vpc-2"
  })
}

resource "aws_internet_gateway" "igw-2" {
  provider = aws.vpc-2
  vpc_id = aws_vpc.vpc-2.id
  tags = merge(var.common_tags, {
    Name = "igw-${local.vpc_2_name}"
  })
}

resource "aws_subnet" "subnet-2" {
  provider   = aws.vpc-2
  vpc_id     = aws_vpc.vpc-2.id
  cidr_block = var.subnet_cidr_2
  map_public_ip_on_launch = true
  tags = merge(var.common_tags, {
    Name = "subnet-${local.vpc_2_name}"
  })
}

resource "aws_route_table" "vpc_2_igw" {
  provider = aws.vpc-2
  vpc_id = aws_vpc.vpc-2.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-2.id
    }
    tags = merge(var.common_tags, {
        Name = "route-table-${local.vpc_2_name}"
    })
}

resource "aws_route" "vpc_2_to_vpc_1" {
  provider = aws.vpc-2
  route_table_id = aws_route_table.vpc_2_igw.id
  destination_cidr_block = var.vpc_cidr_1
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

resource "aws_route_table_association" "subnet_2_association" {
  provider = aws.vpc-2
  subnet_id = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.vpc_2_igw.id
}

