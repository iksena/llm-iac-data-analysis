
locals {
  name   = "test-nat"
  region = "us-west-2"

  az_count        = 1
  cidr_block      = "10.0.0.0/16"
  public_subnets  = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  subnet_availability_zones = [
    "${local.region}a",
    "${local.region}b",
    "${local.region}c",
  ]

}

