variable "vpc_cidr" {
  description = "IPv4 CIDR block for VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "environment" {
  description = "Specify one of: production, staging, development, or development_0000001-development_1000000"
  type = string
  default = "development"
}

variable "availability_zones" {
  description = "Availability zones used by project."
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "name" {
  description = "Name of VPC."
  type = string
  default = "benchmark-vpc"
}

variable "dmz_cidr" {
  description = "IPv4 CIDR blocks for DMZ tier of VPC."
  type = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "semi_private_cidr" {
  description = "IPv4 CIDR blocks for semi-private tier of VPC."
  type = list(string)
  default = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
}

variable "private_cidr" {
  description = "IPv4 CIDR blocks for private tier of VPC."
  type = list(string)
  default = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
}

variable "database_cidr" {
  description = "IPv4 CIDR blocks for database tier of VPC."
  type = list(string)
  default = ["10.0.30.0/24", "10.0.31.0/24", "10.0.32.0/24"]
}

variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}

variable "vpc_tags" {
  description = "VPC-specific tags."
  type        = map(string)
  default     = {}
}
