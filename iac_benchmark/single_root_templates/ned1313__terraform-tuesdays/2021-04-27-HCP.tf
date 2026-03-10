# ── main.tf ────────────────────────────────────
# Create AWS networks
module "vpc" {
  count = length(var.vpcs)
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = var.vpcs[count.index]["name"]
  cidr = var.vpcs[count.index]["cidr"]
  azs = var.vpcs[count.index]["azs"]
  private_subnets = var.vpcs[count.index]["private_subnets"]
  public_subnets = var.vpcs[count.index]["public_subnets"]
  enable_nat_gateway = var.vpcs[count.index]["enable_nat_gateway"]

}
# Create HVN

module "hvn" {
  source = "./hcp_network"
  cloud_region = var.region
  hvn_cidr_block = var.hvn_cidr_block
  prefix = var.prefix

}

# Create peering relationships

module "peering" {
  count = length(var.vpcs)
  source = "./hvn_aws_peering"
  peer_vpc_id = module.vpc[count.index].vpc_id
  route_table_ids = module.vpc[count.index].public_route_table_ids
  hvn_cidr_block = module.hvn.hvn_cidr_block
  hvn_id = module.hvn.hvn_id
}

# Create Vault instance and token

module "vault" {
  source = "./hcp_vault"
  hvn_id = module.hvn.hvn_id
  public_endpoint = var.vault_public_endpoint
  prefix = var.prefix
  
}

# Create Consul instance

module "consul" {
  source = "./hcp_consul"
  hvn_id = module.hvn.hvn_id
  public_endpoint = var.consul_public_endpoint
  prefix = var.prefix
  
}

# Create EC2 instance to access Vault and Consul

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name = "name"

    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}

resource "aws_security_group" "ec2" {
  count = length(var.vpcs)
  name = "allow_ssh"
  description = "Allow SSH to instance"
  vpc_id = module.vpc[count.index].vpc_id

  ingress  {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Allow SSH"
    from_port = 22
    protocol = "tcp"
    to_port = 22
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2" {
  count = length(var.vpcs)
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = var.keyname
  subnet_id   = module.vpc[count.index].public_subnets[0]
  vpc_security_group_ids = [ aws_security_group.ec2[count.index].id ]
  user_data = templatefile("${path.module}/ec2.tmpl",{
    vault_token = nonsensitive(module.vault.vault_admin_token)
    vault_address = module.vault.vault_private_endpoint_url
    consul_token = nonsensitive(module.consul.consul_admin_token)
    consul_address = module.consul.consul_private_endpoint_url
    consul_ca_file = base64decode(module.consul.consul_ca_file)
    consul_config_file = base64decode(module.consul.consul_config_file)
  })
}


# ── variables.tf ────────────────────────────────────
# AWS VPC Values
variable "vpcs" {
    description = "A list of VPC configurations to create and peer with the HVN. Uses the VPC module."
  type = list(object({
      name = string
      cidr = string
      azs = list(string)
      private_subnets = list(string)
      public_subnets = list(string)
      enable_nat_gateway = bool
  }))

  default = [{
      name = "peer-with-hvn"
      cidr = "10.0.0.0/16"
      azs = ["us-east-1a","us-east-1b"]
      private_subnets = []
      public_subnets = ["10.0.0.0/24","10.0.1.0/24"]
      enable_nat_gateway = false
  }]
}

variable "region" {
  description = "Region to use in AWS for all resources"
  default = "us-east-1"
  type = string
}

variable "keyname" {
  description = "Name of key pair to use with EC2 instance"
  type = string
}

## HCP Provider Values
variable "client_id" {
  description = "Client ID of service principal on HCP"
  type = string
  sensitive = true
}

variable "client_secret" {
  description = "Client secret of service principal on HCP"
  type = string
  sensitive = true
}

variable "hvn_cidr_block" {
  description = "CIDR block for the HVN deployment"
  type = string
  default = "172.16.0.0/24"
}

variable "prefix" {
  description = "Naming prefix for HVN resource"
  type = string
  default = "taco"
}

variable "vault_public_endpoint" {
  description = "Whether or not to create a public endpoint for Vault"
  type = bool
  default = false
}

variable "consul_public_endpoint" {
  description = "Whether or not to create a public endpoint for Consul"
  type = bool
  default = false
}

# ── outputs.tf ────────────────────────────────────
output "ec2_public_dns" {
  value = aws_instance.ec2[*].public_ip
}

output "vault_token" {
  value = nonsensitive(module.vault.vault_admin_token)
}

output "vault_private_ip_address" {
  value = module.vault.vault_private_endpoint_url
}

output "consul_token" {
  value = nonsensitive(module.consul.consul_admin_token)
}

output "consul_private_ip_address" {
  value = module.consul.consul_private_endpoint_url
}

# ── terraform.tf ────────────────────────────────────
terraform {
  required_providers {
      hcp = {
          source = "hashicorp/hcp"
          version = "~> 0.5"
      }
      aws = {
          source = "hashicorp/aws"
          version = "~> 3.0"
      }
  }
  backend "remote" {
    organization = "ned-in-the-cloud"

    workspaces {
      name = "terraform-tuesday-hcp"
    }
  }
}

provider "hcp" {
  client_id = var.client_id
  client_secret = var.client_secret
}

provider "aws" {
  region = var.region
}