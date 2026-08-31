locals {
  vpc = {
    dev = {
      # vpc_key = [region, vpc_cidr, [subnet_cidr1, subnet_cidr2, subnet_cidr3]]
      arryw-dev-dublin = ["eu-west-1", "10.0.0.0/23", ["10.0.0.0/26", "10.0.0.64/26", "10.0.0.128/26"]]
    }
  }

  public_routes = {
    dev = {
      some_public_eni_route = ["eu-west-1", "arryw-dev-dublin", "eni", "10.2.0.0/23"]
      some_public_route     = ["eu-west-1", "arryw-dev-dublin", "igw", "8.8.8.8/32"]
    }
  }
}