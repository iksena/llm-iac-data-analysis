# ── main.tf ────────────────────────────────────
provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "eu-west-1"

  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-vpc"
    GithubOrg  = "terraform-aws-modules"
  }
}

################################################################################
# Issue 44 - https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/44
################################################################################

module "vpc_issue_44" {
  source = "../../"

  name = "asymmetrical"
  cidr = "10.0.0.0/16"

  azs              = local.azs
  private_subnets  = ["10.0.1.0/24"]
  public_subnets   = ["10.0.101.0/24", "10.0.102.0/24"]
  database_subnets = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]

  create_database_subnet_group = true
  enable_nat_gateway           = true

  tags = merge({
    Issue = "44"
    Name  = "asymmetrical"
  }, local.tags)
}

################################################################################
# Issue 46 - https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/46
################################################################################

module "vpc_issue_46" {
  source = "../../"

  name = "no-private-subnets"
  cidr = "10.0.0.0/16"

  azs                 = local.azs
  public_subnets      = ["10.0.0.0/22", "10.0.4.0/22", "10.0.8.0/22"]
  private_subnets     = []
  database_subnets    = ["10.0.128.0/24", "10.0.129.0/24"]
  elasticache_subnets = ["10.0.131.0/24", "10.0.132.0/24", "10.0.133.0/24"]

  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_nat_gateway   = false

  tags = merge({
    Issue = "46"
    Name  = "no-private-subnets"
  }, local.tags)
}

################################################################################
# Issue 108 - https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/108
################################################################################

module "vpc_issue_108" {
  source = "../../"

  name = "route-already-exists"
  cidr = "10.0.0.0/16"

  azs             = local.azs
  private_subnets = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.254.240/28", "10.0.254.224/28", "10.0.254.208/28"]

  single_nat_gateway = true
  enable_nat_gateway = true

  tags = merge({
    Issue = "108"
    Name  = "route-already-exists"
  }, local.tags)
}


# ── variables.tf ────────────────────────────────────


# ── outputs.tf ────────────────────────────────────
################################################################################
# Issue 44
################################################################################

# VPC
output "issue_44_vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc_issue_44.vpc_id
}

# Subnets
output "issue_44_private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc_issue_44.private_subnets
}

output "issue_44_public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc_issue_44.public_subnets
}

output "issue_44_database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc_issue_44.database_subnets
}

output "issue_44_elasticache_subnets" {
  description = "List of IDs of elasticache subnets"
  value       = module.vpc_issue_44.elasticache_subnets
}

# NAT gateways
output "issue_44_nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc_issue_44.nat_public_ips
}

################################################################################
# Issue 46
################################################################################

# VPC
output "issue_46_vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc_issue_46.vpc_id
}

# Subnets
output "issue_46_private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc_issue_46.private_subnets
}

output "issue_46_public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc_issue_46.public_subnets
}

output "issue_46_database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc_issue_46.database_subnets
}

output "issue_46_elasticache_subnets" {
  description = "List of IDs of elasticache subnets"
  value       = module.vpc_issue_46.elasticache_subnets
}

# NAT gateways
output "issue_46_nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc_issue_46.nat_public_ips
}

################################################################################
# Issue 108
################################################################################

# VPC
output "issue_108_vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc_issue_108.vpc_id
}

# Subnets
output "issue_108_private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc_issue_108.private_subnets
}

output "issue_108_public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc_issue_108.public_subnets
}

output "issue_108_database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc_issue_108.database_subnets
}

output "issue_108_elasticache_subnets" {
  description = "List of IDs of elasticache subnets"
  value       = module.vpc_issue_108.elasticache_subnets
}

# NAT gateways
output "issue_108_nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc_issue_108.nat_public_ips
}


# ── versions.tf ────────────────────────────────────
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.28"
    }
  }
}
