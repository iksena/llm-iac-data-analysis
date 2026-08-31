module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.bootcamp_id
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
  external_nat_ip_ids    = aws_eip.nat_eip[*].id
  enable_vpn_gateway     = true

  version = "4.0.1"
}
