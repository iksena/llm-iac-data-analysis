variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "Public subnet cird block for VPC"
  type        = string
}

variable "allow_sg_ports" {
  description = "Allow HTTP, HTTPS, SSH ports"
  type        = list(number)
}

variable "common_tags" {
    description = "Tags to apply to all resources"
    type        = map(string)
}