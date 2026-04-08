
locals {
  name   = "test-zicong"
  region = "us-west-2"

  cidr_block      = "10.0.0.0/16"
  public_subnet  = "10.0.2.0/24"
  private_subnet = "10.0.1.0/24"
  subnet_availability_zone = "${local.region}a"
}

