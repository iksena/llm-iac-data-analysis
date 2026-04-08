terraform {
  backend "s3" {
    bucket       = "terrafrom-tfstate-file-s3-bucket"
    encrypt      = true
    key          = "aws/tfstates/examples/29-dynamic-module/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region
}

module "vpc-dev" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-dev"
  cidr = var.cidr_block["dev"]

  azs             = ["eu-west-1a"]
  private_subnets = []
  public_subnets  = []

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "vpc-prod" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-prod"
  cidr = var.cidr_block["prod"]

  azs             = ["eu-west-1b"]
  private_subnets = []
  public_subnets  = []

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }

  depends_on = [module.vpc-dev] # depends on terraform dev module
}

# Example of counting modules
module "vpc-test" {
  count = 2
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-dev"

  azs             = ["eu-west-1a"]
  private_subnets = []
  public_subnets  = []

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev ${count.index + 1}"
  }
}

# Example of counting modules by for_each
module "vpc-test_for_each" {
  for_each = var.vpc_cidr
  source = "terraform-aws-modules/vpc/aws"
  cidr = each.value
  name = "vpc-${each.key}"

  azs             = ["eu-west-1a"]
  private_subnets = []
  public_subnets  = []

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
  }
}