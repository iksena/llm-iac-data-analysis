variable "vpc_name" {
  type = string
  description = "VPC's name"
  default = "main"
}

variable "cidr" {
  type = string
  description =  "CIDR BLOCK for your VPC. For more infos: https://docs.aws.amazon.com/vpc/latest/userguide/configure-your-vpc.html. Default is valid, but not accepted by AWS."
  default     = "0.0.0.0/0"
}

variable "azs" {
  type        = list(string)
  description = "A list of availability zones names or ids in the region"
  default     = []
}

variable "public_subnets" {
  type = list
  description = "A list of public subnets inside the VPC"
  default = []
}

variable "private_subnets" {
  type = list
  description = "A list of private subnets inside the VPC"
  default = []
}

variable "map_public_ip_on_launch" {
  type = bool
  description = "false if you do not want to auto-assign public IP on launch"
  default = true
}

variable "public_subnet_suffix" {
  description = "Suffix to append to public subnets name"
  type        = string
  default     = "public"
}


variable "private_subnet_suffix" {
  description = "Suffix to append to private subnets name"
  type        = string
  default     = "private"
}