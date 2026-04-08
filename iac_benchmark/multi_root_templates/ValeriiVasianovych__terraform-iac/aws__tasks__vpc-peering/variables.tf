# VPC-1
variable "vpc_region_1" {
  description = "The region of the VPC"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr_1" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_1" {
  description = "The CIDR block for the subnet"
  type        = string
  default     = "10.0.10.0/24"
}

# VPC-2
variable "vpc_region_2" {
  description = "The region of the VPC"
  type        = string
  default     = "us-east-2"
}

variable "vpc_cidr_2" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "172.0.0.0/16"
}

variable "subnet_cidr_2" {
  description = "The CIDR block for the subnet"
  type        = string
  default     = "172.0.10.0/24"
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {
    Owner = "DevOps Team"
    Project = "AWS VPC Peering Connection"
  }
}

locals {
  vpc_1_name = "vpc-1"
  vpc_2_name = "vpc-2"
}