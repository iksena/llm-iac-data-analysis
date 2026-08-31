provider "aws" {
  region = var.region_name
  default_tags {
    tags = {
      Owner       = "yBO"
      Team        = "WorldGeeks"
      Environment = "DEV"
      Project     = "Cloudification"
      DeployedBy  = "Terraform"
    }
  }
}
