terraform {
  backend "s3" {
    bucket = "terrafrom-tfstate-file-s3-bucket"
    # dynamodb_table = "terrafrom-tfstate-dynamodb"
    encrypt = true
    key     = "aws/tfstates/aws-instance-vpc/terraform.tfstate"
    region  = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

module "network" {
  source             = "./modules/network"
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  allow_sg_ports     = var.allow_sg_ports
  common_tags        = var.common_tags
}

# module "ec2" {
#   source            = "./modules/ec2"
#   instance_ami      = data.aws_ami.latest_ubuntu.id
#   instance_type     = var.instance_type
#   security_group_id = module.network.security_group_id
#   subnet_id         = module.network.public_subnet_id
#   common_tags       = var.common_tags
# }