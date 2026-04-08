variable "availability_zone" {
  default = "us-west-1b"
}

variable "env_name" {
  default = "serverless-env"
}

variable "vpc_cidr" {
    description = "CIDR Of The VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR Of The Public Subnet"
    default = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR Of The Application Private Subnet"
    default = "10.0.2.0/24"
}
