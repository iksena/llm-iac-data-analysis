variable "region" {
  default = "us-east-1"
}

variable "env" {
  default = "dev"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = [
    "10.0.10.0/24",
    "10.0.11.0/24"
  ]
}

variable "private_subnet_cidrs" {
  default = [
    "10.0.20.0/24",
    "10.0.21.0/24"
  ]
}

variable "common_tags" {
  default = {
    Owner : "Valerii Vasianovych"
  }
}