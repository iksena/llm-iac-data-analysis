terraform {
  backend "s3" {
    bucket = "terrafrom-tfstate-file-s3-bucket"
    # dynamodb_table = "terraform-tfstate-dynamodb"
    encrypt = true
    key     = "aws/tfstates/dev-aws-vpc/terraform.tfstate"
    region  = "us-east-1"
  }
}

provider "aws" {
    region = "eu-central-1"
}

module "vpc_dev" {
    // source = "git@github.com:valeriiVasianovych/terraform-aws-vpc.git//modules/aws_vpc" Use for remote module
    source = "../../modules/aws_vpc"
    region = "eu-central-1"
    env = "dev"
    vpc_cidr = "192.168.0.0/16"
    public_subnet_cidrs = [
        "192.168.10.0/24",
        "192.168.11.0/24",
        "192.168.12.0/24"
    ]
    private_subnet_cidrs = [
        "192.168.20.0/24",
        "192.168.21.0/24",
        "192.168.22.0/24"
    ]
    common_tags = {
        Owner : "Peter Parker"
    }
}