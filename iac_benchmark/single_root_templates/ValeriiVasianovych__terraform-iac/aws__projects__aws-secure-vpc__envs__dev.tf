# ── main.tf ────────────────────────────────────
terraform {
  backend "s3" {
    bucket       = "terrafrom-tfstate-file-s3-bucket"
    encrypt      = true
    key          = "aws/aws-secure-vpc/dev/terraform.tfstate"
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


# ── variables.tf ────────────────────────────────────
# Infrastructure Configuration
variable "region" {
  description = "The AWS region"
  type        = string
  default     = ""
}

variable "env" {
  description = "The environment"
  type        = string
  default     = ""
}

# Network Configuration
variable "hosted_zone_name" {
  description = "The name of the hosted zone"
  type        = string
  default     = ""
}

# Instance Configuration
variable "instance_types" {
  description = "Map of instance types for different components"
  type        = map(string)
  default = {
    # Bastion host instance type - Used as a secure jump server to access private resources
    # bastion         = ""
    public_instance = ""
    private_instance = ""
    db_instance     = ""
  }
}

variable "key_name" {
  description = "The name of the key pair to be used for SSH access"
  type        = string
  default     = ""
}

# VPN Configuration
variable "vpn_server_cert_arn" {
  description = "The name of the server certificate"
  type        = string
  default     = ""
}

variable "vpn_client_cert_arn" {
  description = "The name of the client certificate"
  type        = string
  default     = ""
}



# ── outputs.tf ────────────────────────────────────
# VPC Information
output "vpc_region" {
  value       = module.aws_vpc.region
  description = "The AWS region of the VPC."
}

output "vpc_env" {
  value       = module.aws_vpc.env
  description = "The environment of the VPC."
}

output "vpc_id" {
  value       = module.aws_vpc.vpc_id
  description = "The ID of the VPC."
}

output "vpc_cidr_block" {
  value       = module.aws_vpc.vpc_cidr_block
  description = "The CIDR block of the VPC."
}

# Subnet Information
output "public_subnet_cidr_blocks" {
  value       = module.aws_vpc.public_subnet_cidr_blocks
  description = "The CIDR blocks of the public subnets."
}

output "public_subnet_ids" {
  value       = module.aws_vpc.public_subnet_ids
  description = "The IDs of the public subnets."
}

output "private_subnet_cidr_blocks" {
  value       = module.aws_vpc.private_subnet_cidr_blocks
  description = "The CIDR blocks of the private subnets."
}

output "private_subnet_ids" {
  value       = module.aws_vpc.private_subnet_ids
  description = "The IDs of the private subnets."
}

output "db_private_subnet_cidr_blocks" {
  value       = module.aws_vpc.db_private_subnet_cidr_blocks
  description = "The CIDR blocks of the database private subnets."
}

output "db_private_subnet_ids" {
  value       = module.aws_vpc.db_private_subnet_ids
  description = "The IDs of the database private subnets."
}

# Instance Information
// output "bastion_instance_id" {
//   value       = module.aws_compute.bastion_instance_id
//   description = "List of IDs of the bastion instances managed by the ASG. Bastion hosts are used as secure jump servers to access private resources."
// }

// output "bastion_instance_ip" {
//   value       = module.aws_compute.bastion_instance_ip
//   description = "List of public IPs of the bastion instances managed by the ASG. These IPs are used to SSH into the bastion hosts for accessing private resources."
// }

// output "bastion_host_azs" {
//   value       = module.aws_compute.bastion_host_azs
//   description = "List of Availability Zones of the bastion instances. Bastion hosts are distributed across AZs for high availability."
// }

output "private_instance_id" {
  value       = module.aws_compute.private_instance_id
  description = "List of IDs of the private instances managed by the ASG."
}

output "private_instance_ip" {
  value       = module.aws_compute.private_instance_ip
  description = "List of private IPs of the private instances managed by the ASG."
}

output "private_instances_azs" {
  value       = module.aws_compute.private_instances_azs
  description = "List of Availability Zones of the private instances."
}

# DNS Information
output "application_domain_name" {
  value       = module.aws_compute.application_domain_name
  description = "The fully qualified domain name (FQDN) of the application, or null if no private subnets are created."
}


# ── datasource.tf ────────────────────────────────────
# AWS Account Information
data "aws_caller_identity" "current" {
  # Get current AWS account ID
}

# AMI Configurations
data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"] # Canonical
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

# data "aws_ami" "latest_openvpn" {
#   owners      = ["444663524611"] # OpenVPN Technologies, Inc.
#   most_recent = true
#
#   filter {
#     name   = "name"
#     values = ["OpenVPN Access Server Community Image"]
#   }
#
#   filter {
#     name   = "architecture"
#     values = ["x86_64"]
#   }
#
#   filter {
#     name   = "root-device-type"
#     values = ["ebs"]
#   }
# }

# DNS Configuration
data "aws_route53_zone" "hosted_zone" {
  name = var.hosted_zone_name
}
