variable "region" {
  default = "us-east-1"
}

variable "env" {
  default = "dev"
}

variable "vpc_cidr" {
  default = "192.168.0.0/16"
}

variable "public_subnet_cidrs" {
  default = [
    "192.168.10.0/24"
  ]
}

variable "private_subnet_cidrs" {
  default = [
    "192.168.20.0/24"
  ]
}

variable "common_tags" {
  default = {
    Owner : "Valerii Vasianovych"
    Project : "Terraform AWS"
  }
}