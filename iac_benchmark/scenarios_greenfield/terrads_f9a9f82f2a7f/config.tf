#
# Providers
#
provider "aws" {
  region  = var.region
}

#
# Backend Config (partial)
#
terraform {
  required_version = ">= 0.12.19"

}
