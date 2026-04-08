module "vpc" {
  source = "terraform-aws-modules/vpc/aws"


  name            = "terraform.vpc"
  cidr            = "10.0.0.0/16"
  azs             = data.aws_availability_zones.available.names
  private_subnets = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  public_subnets  = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
  tags = {
    Account           = "Subnet in Account: ${data.aws_caller_identity.current.account_id}"
    Region            = "Subnet in Region: ${data.aws_region.current.name}"
    RegionDescription = "Region Description: ${data.aws_region.current.description}"
  }
}