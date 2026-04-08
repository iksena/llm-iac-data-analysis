# variable "az" {}
variable "account_id" {}
variable "environment" {}
# variable "allow_public_ssh" {} ## TODO: XXX Dial this down, to be only limited blocks!
variable "domain_name" {}

variable "private_subnets" {
  description = "Hash map of private subnets {name:{'cidr': cidr, 'az': az}}. At least one required."
}

variable "public_subnets" {
  description = "Hash map of public subnets {name:{'cidr': cidr, 'az': az}}. At least one required."
}

variable "region" {}
variable "vpc_cidr" {}
variable "vpc_name" {}
variable "vpc_private_cidr" {}
variable "vpc_public_cidr" {}

variable "vpc_tags" { default = {} }
variable "public_subnet_tags" { default = {} }
variable "private_subnet_tags" { default = {} }
