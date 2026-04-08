provider "aws" {
  region = var.region_name[0]
  alias  = "region-1"
}

provider "aws" {
  region = var.region_name[1]
  alias  = "region-2"
}