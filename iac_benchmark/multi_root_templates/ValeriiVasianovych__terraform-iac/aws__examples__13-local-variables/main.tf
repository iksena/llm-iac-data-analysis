terraform {
  backend "s3" {
    bucket  = "terrafrom-tfstate-file-s3-bucket"
    # dynamodb_table = "terraform-tfstate-dynamodb"
    encrypt = true
    key     = "aws/tfstates/local-variables/terraform.tfstate"
    region  = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region = var.region
}

locals {
  full_project_name = "${var.project} in ${var.env}"
  location          = "Country: ${var.country} City: ${var.city}"
  az_list           = join(", ", data.aws_availability_zones.available.names)
  region            = data.aws_region.current.name
  region_az         = "In ${local.region} region are az: ${local.az_list}"
}