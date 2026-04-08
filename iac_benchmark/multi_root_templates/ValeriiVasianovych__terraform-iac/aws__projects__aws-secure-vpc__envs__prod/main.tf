terraform {
  backend "s3" {
    bucket       = "terrafrom-tfstate-file-s3-bucket"
    encrypt      = true
    key          = "aws/aws-secure-vpc/prod/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Owner       = "Valerii Vasianovych with ID"
      Project     = "Cybersecurity Project in ${var.region} region. Project: AWS Cloud and Terraform IaC"
      Environment = var.env
      Region      = "Region: ${var.region}"
    }
  }
}

# VPC Module Configuration
module "aws_vpc" {
  source = "../../modules/aws_vpc"
  
  # Basic Configuration
  region     = var.region
  env        = var.env
  account_id = data.aws_caller_identity.current.id
  
  # Network Configuration
  vpc_cidr                = "10.0.0.0/16"
  public_subnet_cidrs     = ["10.0.10.0/24", "10.0.11.0/24"]
  private_subnet_cidrs    = ["10.0.20.0/24", "10.0.21.0/24"]
  db_private_subnet_cidrs = []
}

# Compute Module Configuration
module "aws_compute" {
  source = "../../modules/aws_compute"
  depends_on = [module.aws_vpc]

  # Basic Configuration
  region     = module.aws_vpc.region
  env        = module.aws_vpc.env
  account_id = data.aws_caller_identity.current.id

  # Network Configuration
  vpc_id                = module.aws_vpc.vpc_id
  public_subnet_ids     = module.aws_vpc.public_subnet_ids
  private_subnet_ids    = module.aws_vpc.private_subnet_ids
  db_private_subnet_ids = module.aws_vpc.db_private_subnet_ids
  client_vpn_cidr_block = "10.200.0.0/22"

  # Instance Configuration
  instance_type_public_instance  = var.instance_types["public_instance"]
  instance_type_private_instance = var.instance_types["private_instance"]
  instance_type_db_instance      = var.instance_types["db_instance"]
  ami                            = data.aws_ami.latest_ubuntu.id
  key_name                       = var.key_name

  # DNS Configuration
  hosted_zone_name = var.hosted_zone_name
  hosted_zone_id   = data.aws_route53_zone.hosted_zone.zone_id

  # Security Configuration
  vpn_server_cert_arn = var.vpn_server_cert_arn
  vpn_client_cert_arn = var.vpn_client_cert_arn
  public_sg          = [443, 1194, 943, 945]
  private_sg         = [22, 80, 443, 5000]
  db_private_sg      = []
}
