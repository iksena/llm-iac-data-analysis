locals {
  # This is used to divide the VPC subnet IP range into 2 * (number of AZ) subranges
  subnet_count = length(data.aws_availability_zones.available.names)
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  type    = string
  default = "benchmark-vpc"
}

variable "ssh_inbound" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}
