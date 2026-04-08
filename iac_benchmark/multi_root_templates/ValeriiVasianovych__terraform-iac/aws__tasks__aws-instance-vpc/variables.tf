variable "region" {
  description = "AWS region to deploy instance"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet cird block for VPC"
  type        = string
  default     = "10.0.10.0/24"
}

variable "instance_type" {
  description = "Definition of instance type for EC2"
  type        = string
  default     = "t2.micro"
}

variable "allow_sg_ports" {
  description = "Allow HTTP, HTTPS, SSH ports"
  type        = list(number)
  default     = [80, 443, 22]
}

variable "common_tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Owner       = "Valerii Vasianovych"
    Project     = "AWS Instance Creation"
    Environment = "Development"
  }
}