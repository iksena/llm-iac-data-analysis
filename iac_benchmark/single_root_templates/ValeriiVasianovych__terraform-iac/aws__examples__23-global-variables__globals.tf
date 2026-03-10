terraform {
  backend "s3" {
    bucket       = "terrafrom-tfstate-file-s3-bucket"
    encrypt      = true
    key          = "aws/tfstates/examples/23-global-variables/globals/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region
}

#===============================================
#===============================================

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "common_tags" {
  type = map(string)
  default = {
    Owner   = "Valerii Vasianovych"
    Project = "Terraform AWS"
  }
}

variable "security_group_ingress" {
  type    = list(number)
  default = [22, 80, 443]
}

variable "instance_types" {
  type = map(string)
  default = {
    micro  = "t2.micro"
    small  = "t2.small"
    medium = "t2.medium"
  }
}

#===============================================
#===============================================

output "region" {
  value = var.region
}

output "env" {
  value = var.env
}

output "common_tags" {
  value = var.common_tags
}

output "security_group_ingress" {
  value = var.security_group_ingress
}

output "instance_types" {
  value = var.instance_types
}
