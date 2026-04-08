module "vpc_networking" {
  source = "./modules/vpc_networking"

  account_id       = local.account_id
  environment      = var.env_prefix
  domain_name      = var.vpc_domain
  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  region           = var.region
  vpc_cidr         = var.vpc_cidr
  vpc_name         = var.vpc_name
  vpc_private_cidr = var.vpc_private_cidr
  vpc_public_cidr  = var.vpc_public_cidr
  vpc_tags = {
  }
  public_subnet_tags = {
  }
  private_subnet_tags = {
  }
}
