# ── main.tf ────────────────────────────────────
terraform {
  backend "s3" {
    bucket = "terrafrom-tfstate-file-s3-bucket"
    # dynamodb_table = "terraform-tfstate-dynamodb"
    encrypt = true
    key     = "aws/tfstates/prod-aws-vpc/terraform.tfstate"
    region  = "us-east-1"
  }
}

provider "aws" {
    region = "eu-west-1"
}

module "vpc_prod" {
    source = "../../modules/aws_vpc"
    region = "eu-west-1"
    env = "prod"
    vpc_cidr = "192.168.0.0/16"
    public_subnet_cidrs = [
        "192.168.10.0/24"
    ]
    private_subnet_cidrs = [
        "192.168.20.0/24"
    ]
    common_tags = {
        Owner : "William Smith"
    }
}

# ── outputs.tf ────────────────────────────────────
output "vpc_prod_id" {
  value = module.vpc_prod.vpc_id
}

output "vpc_prod_public_subnet_cidrs" {
  value = module.vpc_prod.public_subnet_cidrs
}

output "vpc_prod_private_subnet_cidrs" {
  value = module.vpc_prod.private_subnet_cidrs
}